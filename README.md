# LemonTree.Automation.Custom.Docker

A set of custom Docker images extending LemonTree.Automation with:
- **Latest Git** (from git-core PPA)
- **Git LFS** (latest from official releases)
- **PowerShell (pwsh)** (latest from Microsoft repo) - Set as default shell
- **Bash**
- **SQLite3**
- **Go** - Latest version from official distribution
  
- **LemonTree.Automation** - Available as `lemontree.automation` command
- **LemonTree.Pipeline.Tools.ModelCheck** - Available as `lemontree.modelcheck` command
- **LemonTree.Connect.Automation.Polarion** - Available as `lemontree.polarion` command
- **LemonTree.Connect.Jama.Automation** - Available as `lemontree.jama` command

Image variants:
- **Classic** (`ghcr.io/danielsiegl/lemontree.automation.custom.docker`) - without Playwright/SVG tooling
- **Playwright** (`ghcr.io/danielsiegl/lemontree.automation.custom.docker-playwright`) - based on the classic image, adds Node.js + Playwright/Chromium and `svg2png`

## Quick Start

### Using from GitHub Packages

Pull and run the classic image:
```bash
docker pull ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest
```

Pull and run the Playwright image:
```bash
docker pull ghcr.io/danielsiegl/lemontree.automation.custom.docker-playwright:latest
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker-playwright:latest
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
PS /> sqlite3 --version
PS /> go version
```

### Running Specific Commands

```bash
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.automation diff --help"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.modelcheck --help"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.polarion --help"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.jama --help"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "sqlite3 --version"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker-playwright:latest -c "node --version"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker-playwright:latest -c "svg2png input.svg output.png"
```

### Using Bash

Override the default PowerShell:
```bash
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest /bin/bash
```

### SVG to PNG Conversion

Convert an SVG file to PNG using the built-in Playwright/Chromium pipeline:

```bash
# Mount a local directory and convert a file
docker run --rm -v $(pwd):/work ghcr.io/danielsiegl/lemontree.automation.custom.docker-playwright:latest \
  -c "svg2png /work/diagram.svg /work/diagram.png"

# Specify explicit dimensions
docker run --rm -v $(pwd):/work ghcr.io/danielsiegl/lemontree.automation.custom.docker-playwright:latest \
  -c "svg2png /work/diagram.svg /work/diagram.png 1920 1080"
```

Inside the container:
```bash
svg2png input.svg output.png          # auto-detect dimensions from SVG
svg2png input.svg output.png 800 600  # explicit width x height
```

## Local Development

Build locally:
```bash
docker build --target classic -t lemontree.automation.custom:latest .
docker build --target playwright -t lemontree.automation.custom-playwright:latest .
docker run -it lemontree.automation.custom:latest
docker run -it lemontree.automation.custom-playwright:latest
```

## CI/CD

The GitHub Actions workflow automatically builds and publishes both images to GitHub Container Registry on:
- Push to `main` or `master` branch (tagged as `latest`)
- Push of version tags (`v*` format, e.g., `v1.0.0`)
- Pull requests (build only, no push)
