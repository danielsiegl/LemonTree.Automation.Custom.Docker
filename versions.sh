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
echo "Installed Components:"
echo ""

# Git - extract version number only
git_version=$(git --version 2>&1 | awk '{print $3}')
print_version "git" "Git $git_version"

# Git LFS - extract version number only
git_lfs_version=$(git lfs version 2>&1 | head -n 1 | awk -F'/' '{print $1}' | awk '{print $NF}')
print_version "git lfs" "Git LFS $git_lfs_version"

# PowerShell
pwsh_version=$(pwsh --version 2>&1 | awk '{print $NF}')
print_version "pwsh" "PowerShell $pwsh_version"

# Go - extract version number only (remove "linux/amd64" suffix)
go_version=$(go version 2>&1 | awk '{print $3}')
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

echo ""
echo "════════════════════════════════════════════════════════════"
echo ""


