# SSMS 22 Extension Installation Script
# Based on the working SSMS-Executor pattern

$ErrorActionPreference = "Stop"

Write-Host "Poor Man's T-SQL Formatter for SSMS 22" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check for Administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: Please run this script as Administrator" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

$extensionPath = "C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE\Extensions\PoorMansTSqlFormatter"
$sourcePath = "C:\Users\julqui.quispe\PoorMansTSqlFormatter\PoorMansTSqlFormatterSSMSPackage22\bin\Release"

# Check if source files exist
if (-not (Test-Path "$sourcePath\PoorMansTSqlFormatterSSMSPackage.vsix")) {
    Write-Host "ERROR: Extension files not found at: $sourcePath" -ForegroundColor Red
    Write-Host "Please build the project first." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Installing Poor Man's T-SQL Formatter for SSMS 22..." -ForegroundColor Green
Write-Host ""

# Step 1: Create extension directory
Write-Host "Step 1: Creating extension directory..." -ForegroundColor Yellow
if (-not (Test-Path $extensionPath)) {
    New-Item -Path $extensionPath -ItemType Directory -Force | Out-Null
    Write-Host "  Created: $extensionPath" -ForegroundColor Green
} else {
    Write-Host "  Directory already exists" -ForegroundColor Gray
}

# Step 2: Copy extension files
Write-Host "Step 2: Copying extension files..." -ForegroundColor Yellow
$files = Get-ChildItem -Path $sourcePath -File
$copied = 0
foreach ($file in $files) {
    Copy-Item -Path $file.FullName -Destination $extensionPath -Force
    $copied++
}
Write-Host "  Copied $copied files to extension directory" -ForegroundColor Green

# Step 3: Trigger SSMS extension refresh
Write-Host "Step 3: Triggering extension refresh..." -ForegroundColor Yellow
$configFile = "C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE\Extensions\extensions.configurationchanged"
try {
    # Touch the configuration changed file to trigger extension refresh
    [System.IO.File]::WriteAllText($configFile, [DateTime]::Now.ToString())
    Write-Host "  Triggered extension refresh" -ForegroundColor Green
} catch {
    Write-Host "  Note: Could not trigger refresh (this is normal)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Installation completed successfully!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT: Please restart SSMS 22 completely!" -ForegroundColor Yellow
Write-Host ""
Write-Host "After restart, look for:" -ForegroundColor White
Write-Host "  - Tools menu: Format T-SQL Code" -ForegroundColor White
Write-Host "  - Tools menu: T-SQL Formatting Options" -ForegroundColor White
Write-Host "  - Keyboard shortcut: Ctrl+K, Ctrl+F" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to exit"
