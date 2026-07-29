# LemonTree.Automation.Custom.Docker

A custom Docker image extending LemonTree.Automation with:
- **Latest Git** (from git-core PPA)
- **Git LFS** (latest from official releases)
- **PowerShell (pwsh)** (latest from Microsoft repo) - Set as default shell
- **Bash**
- **SQLite3**
- **Go** - Latest version from official distribution
- **Node.js** - LTS v20 (for Playwright)
- **Playwright + Chromium** - Browser-based SVG to PNG conversion via `svg2png` command
- **LemonTree.Automation** - Available as `lemontree.automation` command
- **LemonTree.Pipeline.Tools.ModelCheck** - Available as `lemontree.modelcheck` command
- **LemonTree.Connect.Automation.Polarion** - Available as `lemontree.polarion` command
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
PS /> sqlite3 --version
PS /> go version
PS /> node --version
PS /> svg2png input.svg output.png
```

### Running Specific Commands

```bash
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.automation diff --help"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.modelcheck --help"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.polarion --help"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "lemontree.jama --help"
docker run -it ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest -c "sqlite3 --version"
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
docker run --rm -v $(pwd):/work ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest \
  -c "svg2png /work/diagram.svg /work/diagram.png"

# Specify explicit dimensions
docker run --rm -v $(pwd):/work ghcr.io/danielsiegl/lemontree.automation.custom.docker:latest \
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
docker build -t lemontree.automation.custom:latest .
docker run -it lemontree.automation.custom:latest
```

## CI/CD

The GitHub Actions workflow automatically builds and publishes the image to GitHub Container Registry on:
- Push to `main` or `master` branch (tagged as `latest`)
- Push of version tags (`v*` format, e.g., `v1.0.0`)
- Pull requests (build only, no push)
