build-docs:
	@echo "Building docs..."
	@cd mkdocs && mkdocs build && cp -R site/* ../docs/
	@echo "Docs built successfully."

serve-docs:
	@echo "Serving docs..."
	@cd mkdocs && mkdocs serve
	@echo "Docs served successfully."