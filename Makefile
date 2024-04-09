build-docs:
	@echo "Building docs..."
	@cd mkdocs && mkdocs build && cp -R site/* ../docs/
	@echo "Docs built successfully."

serve-docs:
	@echo "Serving docs..."
	@cd mkdocs && mkdocs serve
	@echo "Docs served successfully."

apply-infrastructure:
	# iterates through infrastructure folder and inside the subfolders it executes the terraform apply command
	@echo "Applying infrastructure..."
	@find infrastructure -mindepth 3 -maxdepth 3 -type d -exec bash -c "cd {} && terraform init && terraform apply -auto-approve" \;
	@echo "Infrastructure applied successfully."

apply:
	$(eval BASEDIR=$(shell pwd))
	@echo "Applying shared configurations..."
	@for dir in $(shell find infrastructure/environment -type d -name shared); do \
		echo "Applying in $$dir"; \
		cd $$dir && terraform init && terraform apply -auto-approve; \
		cd $(BASEDIR); \
	done
	@echo "Applying region-specific configurations..."
	@for dir in $(shell find infrastructure/environment -type d -not \( -path '*/shared' -prune \) -not \( -path '*/.terraform' -prune \)); do \
		if [ $$dir != "infrastructure/environment" ] && [ $$(dirname $$dir) != "infrastructure/environment" ]; then \
			shared_dir=$$(dirname $$dir)/shared; \
			echo $(shared_dir); \
			cd $$shared_dir && terraform output > terraform.tfvars; \
			mv -f terraform.tfvars $(BASEDIR)/$$dir; \
			cd $(BASEDIR); \
			echo "Applying in $$dir"; \
			[ -f $$dir/backend.tfvars ] || (echo "Please execute make apply-init before applying the environment" && exit 1); \
			cd $$dir && terraform init -backend-config=backend.tfvars && terraform apply -auto-approve; \
			cd $(BASEDIR); \
		fi; \
	done

apply-init:
	$(eval BASEDIR=$(shell pwd))
	@echo "BASEDIR: $(BASEDIR)"
	# initialize storage account for terraform remote state
	@echo "Initializing remote state..."
	$(eval repo=$(shell bash -c "git config --get remote.origin.url | sed -n 's#.*:##;s/\.git$$//p'"))
	$(eval TF_VAR_issuer=$(repo))
	echo $(TF_VAR_issuer)
	printenv
	cd infrastructure/remote_state && terraform init && TF_VAR_issuer=$(TF_VAR_issuer) terraform apply -auto-approve
	terraform output -json > terraform.output
	$(eval OUTPUT=$(BASEDIR)/infrastructure/remote_state/terraform.output)
	@echo "OUTPUT: $(OUTPUT)"
	cd $(BASEDIR)
	# check if the cli tool "jq" is installed
	@jq --version > /dev/null 2>&1 || (echo "yq is not installed. Please install it" && exit 1)
	# iterate through the environment folders and modify the provider.tf file to include the output of the storage account name and the resource group name
	@for dir in $(shell find infrastructure/environment -type d -not \( -path '*/.terraform' -prune \)); do \
		if [ $$dir != "infrastructure/environment" ] && [ $$(dirname $$dir) != "infrastructure/environment" ]; then \
			echo "get values from $(OUTPUT)"; \
			storage_account_name=$$(jq '.sa_name.value' $(OUTPUT)); \
			echo "set storage_account_name to $$storage_account_name"; \
			resource_group_name=$$(jq '.rg_name.value' $(OUTPUT)); \
			echo "set resource_group_name to $$resource_group_name"; \
			key="\"$$(basename $$(dirname $$dir)).$$(basename $$dir).tfstate"\"; \
			echo "set key to $$key"; \
			echo "Initializing in $$dir"; \
			cd $$dir && echo "storage_account_name = $$storage_account_name" > backend.tfvars && echo "resource_group_name = $$resource_group_name" >> backend.tfvars && echo "key = $$key" >> backend.tfvars; \
			cd $(BASEDIR); \
		fi; \
	done


test:
	@echo "Running tests..."