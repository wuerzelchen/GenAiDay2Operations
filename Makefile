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
			cd $$dir && terraform init && terraform apply -auto-approve; \
			cd $(BASEDIR); \
		fi; \
	done

test:
	@echo "Running tests..."