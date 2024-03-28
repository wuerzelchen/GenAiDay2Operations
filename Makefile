build-docs:
	@echo "Building docs..."
	@cd mkdocs && mkdocs build && cp -R site/* ../docs/
	@echo "Docs built successfully."