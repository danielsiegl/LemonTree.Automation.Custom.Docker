#!/usr/bin/env pwsh

<#
.SYNOPSIS
Build the LemonTree.Automation.Custom.Docker image and display its size.

.DESCRIPTION
This script builds the Docker image and outputs detailed information about the build
including the final image size.

.EXAMPLE
./build.ps1
./build.ps1 -NoCache
#>

param(
    [switch]$NoCache = $false,
    [string]$ImageTag = "lemontree.automation.custom:latest"
)

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Building Docker Image" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Build the image
$buildCommand = "docker build -t $ImageTag"
if ($NoCache) {
    $buildCommand += " --no-cache"
}
$buildCommand += " ."

Write-Host "Command: $buildCommand" -ForegroundColor Yellow
Write-Host ""

Invoke-Expression $buildCommand

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Quick Commands:" -ForegroundColor Yellow
Write-Host ""
Write-Host "Run the image (sh):"
Write-Host "  docker run -it $ImageTag" -ForegroundColor Gray
Write-Host ""
Write-Host "Run the image (bash):"
Write-Host "  docker run -it $ImageTag /bin/bash" -ForegroundColor Gray
Write-Host ""
Write-Host "Run with PowerShell:"
Write-Host "  docker run -it $ImageTag pwsh" -ForegroundColor Gray
Write-Host ""
Write-Host "Run a command:"
Write-Host "  docker run -it $ImageTag lemontree.automation --help" -ForegroundColor Gray
Write-Host ""

# Get image size
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

$imageSize = docker images --filter "reference=$ImageTag" --format "{{.Size}}"
Write-Host "Image Size: $imageSize" -ForegroundColor Green
Write-Host ""

# Get CVE count using docker scout
try {
    Write-Host "Scanning for vulnerabilities..." -ForegroundColor Yellow
    
    # Run docker scout and capture output
    $scoutOutput = & docker scout cves "$ImageTag" 2>&1 | Out-String
    
    # Count critical CVEs
    $criticalMatches = [regex]::Matches($scoutOutput, 'x CRITICAL')
    $criticalCount = $criticalMatches.Count
    
    if ($criticalCount -gt 0) {
        Write-Host "Critical CVEs: $criticalCount" -ForegroundColor Red
    }
    else {
        Write-Host "Critical CVEs: $criticalCount" -ForegroundColor Green
    }
}
catch {
    Write-Host "Could not retrieve CVE information: $_" -ForegroundColor Yellow
}

Write-Host ""
