# LemonTree.Automation.Custom.Docker

A custom Docker image extending LemonTree.Automation with:
- **Latest Git** (from git-core PPA) v2.53.0
- **Git LFS** v3.3.0
- **PowerShell (pwsh)** v7.5.5 - Set as default shell
- **Bash**
- **LemonTree.Automation** - Available as `lemontree.automation` command
- **LemonTree.Pipeline.Tools.ModelCheck** v2.5.5.22 - Available as `lemontree-modelcheck` command

## Quick Start

### Using from GitHub Packages

Pull and run the image:
```bash
docker pull ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest
```

### Available Commands

Inside the container, you can use:

```powershell
PS /> lemontree.automation --help
PS /> lemontree-modelcheck --help
PS /> git --version
PS /> git lfs version
```

### Running Specific Commands

```bash
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.automation diff --help"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree-modelcheck --help"
```

### Using Bash

Override the default PowerShell:
```bash
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest /bin/bash
```

## Local Development

Build locally:
```bash
docker build -t lemontree.automation.custom:latest .
docker run -it lemontree.automation.custom:latest
```

## CI/CD

The GitHub Actions workflow automatically builds and publishes the image to GitHub Container Registry on:
- Push to `main` or `master` branch (tagged as `latest`)
- Push of version tags (`v*` format, e.g., `v1.0.0`)
- Pull requests (build only, no push)
