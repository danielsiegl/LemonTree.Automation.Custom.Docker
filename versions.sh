#!/bin/bash

# Display version information on startup
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     LemonTree.Automation.Custom.Docker - Version Report    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Function to print version with nice formatting
print_version() {
    local name="$1"
    local version_output="$2"
    printf "  %-40s %s\n" "$name:" "$version_output"
}

# Collect and display versions
echo "Docker Image Summary:"
echo ""

# Operating System
if [ -f /etc/os-release ]; then
    os_name=$(grep "^NAME=" /etc/os-release | cut -d'"' -f2)
    os_version=$(grep "^VERSION=" /etc/os-release | cut -d'"' -f2)
    print_version "os" "$os_name $os_version"
else
    os_info=$(uname -s -r)
    print_version "os" "$os_info"
fi

# Git - extract version number only
git_version=$(git --version 2>&1 | awk '{print $3}')
print_version "git" "Git $git_version"

# Git LFS - extract version number only
git_lfs_version=$(git lfs version 2>&1 | head -n 1 | awk -F'/' '{print $2}' | awk '{print $1}')
print_version "git lfs" "Git LFS $git_lfs_version"

# PowerShell
pwsh_version=$(pwsh --version 2>&1 | awk '{print $NF}')
print_version "pwsh" "PowerShell $pwsh_version"

# Go - extract version number only (remove "go" prefix)
go_version=$(go version 2>&1 | awk '{print $3}' | sed 's/^go//')
print_version "go" "Go $go_version"

# LemonTree.Automation - extract line after Copyright © LieberLieber Software GmbH
if [ -f /app/lemontree.automation ]; then
    lt_version=$(/app/lemontree.automation --version 2>&1 | grep -A 1 "Copyright © LieberLieber Software GmbH" | tail -1)
    print_version "lemontree.automation" "$lt_version"
fi

# LemonTree.Pipeline.Tools.ModelCheck - extract first line (contains version)
if [ -f /app/lemontree.pipeline.tools.modelcheck ]; then
    modelcheck_version=$(/app/lemontree.pipeline.tools.modelcheck --version 2>&1 | head -1)
    print_version "lemonTree.modelcheck" "$modelcheck_version"
fi

# LemonTree.Connect.Automation.Polarion - extract line after Copyright © LieberLieber Software GmbH
if [ -f /app/LemonTree.Connect.Polarion.Automation ]; then
    polarion_version=$(/app/LemonTree.Connect.Polarion.Automation --version 2>&1 | grep -A 1 "Copyright © LieberLieber Software GmbH" | tail -1)
    print_version "lemontree.polarion" "$polarion_version"
fi

# LemonTree.Connect.Automation.Jama - extract line after Copyright © LieberLieber Software GmbH
if [ -f /app/LemonTree.Connect.Jama.Automation ]; then
    jama_version=$(/app/LemonTree.Connect.Jama.Automation --version 2>&1 | grep -A 1 "Copyright © LieberLieber Software GmbH" | tail -1)
    print_version "lemontree.jama" "$jama_version"
fi

# Node.js
if command -v node >/dev/null 2>&1; then
    node_version=$(node --version 2>&1)
    print_version "node" "Node.js $node_version"
fi

# Playwright (Node.js) - extract version from installed package
if [ -f /opt/svg2png/node_modules/playwright/package.json ]; then
    playwright_version=$(node -e "console.log(require('/opt/svg2png/node_modules/playwright/package.json').version)" 2>&1)
    print_version "playwright/node (chromium)" "Playwright $playwright_version"
fi

# Playwright (Python) - extract version from pip
if command -v python3 >/dev/null 2>&1; then
    py_playwright_output=$(python3 -m playwright --version 2>&1)
    if echo "$py_playwright_output" | grep -q "Version"; then
        py_playwright_version=$(echo "$py_playwright_output" | awk '{print $2}')
        print_version "playwright/python (chromium)" "Playwright $py_playwright_version"
    fi
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo ""


