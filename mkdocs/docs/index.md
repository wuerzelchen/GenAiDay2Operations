# Welcome to GenAiDay2Operations
This repository serves the purpose of providing an example for a full project structure with all best practices impelmented. Like CI/CD, Application Tracing, Security etc.

## Project layout
    mkdocs/
        mkdocs.yml    # The configuration file.
        site/         # The directory where the site is built.
        docs/
            index.md  # The documentation homepage.
            ...       # Other markdown pages, images and other files.

## Build the documentation and push it to the gh-pages folder

```bash
mkdocs build && cp -R site/* ../docs/
```