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