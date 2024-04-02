# Welcome to GenAiDay2Operations
This repository serves the purpose of providing an example for a full project structure with all best practices impelmented. Like CI/CD, Application Tracing, Security etc.

## Project layout
    mkdocs/
        mkdocs.yml    # The configuration file.
        site/         # The directory where the site is built.
        docs/
            index.md  # The documentation homepage.
            ...       # Other markdown pages, images and other files.

## First things first
1. Enable gpgsign = true in either the .git/config file or globally in the .gitconfig file.
> This is needed, since this repo does not allow unsigned commits.
```bash
[commit]
    gpgSign = true
```
2. Do the same for the tag signing.
```bash
[tag]
    gpgSign = true
```

3. Initially apply the remote_state environment with the following command:
```bash
make apply-init
```

4. Apply the rest of the environments locally with the following command:
```bash
make apply
```

## Build the documentation and push it to the gh-pages folder

```bash
cd mkdocs
mkdocs build && cp -R site/* ../docs/
```