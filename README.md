# LemonTree.Automation.Custom.Docker

A custom Docker image extending LemonTree.Automation with:
- **Latest Git** (from git-core PPA)
- **Git LFS** (latest from official releases)
- **PowerShell (pwsh)** (latest from Microsoft repo) - Set as default shell
- **Bash**
- **Go** - Latest version from official distribution
- **LemonTree.Automation** v4.2.2.0 - Available as `lemontree.automation` command
- **LemonTree.Pipeline.Tools.ModelCheck** v2.5.6.23 - Available as `lemontree.modelcheck` command
- **LemonTree.Connect.Automation.Polarion** v3.1.0.0 - Available as `lemontree.polarion` command
- **LemonTree.Connect.Jama.Automation** - Available as `lemontree.jama` command

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
PS /> lemontree.modelcheck --help
PS /> lemontree.polarion --help
PS /> lemontree.jama --help
PS /> git --version
PS /> git lfs version
PS /> go version
```

### Running Specific Commands

```bash
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.automation diff --help"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.modelcheck --help"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.polarion --help"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.jama --help"
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
