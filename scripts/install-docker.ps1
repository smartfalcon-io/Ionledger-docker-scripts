# ============================================
# Docker Desktop Installation Script for Windows
# Requires: Administrator privileges
# Author: IonLedger
# ============================================

# Check if running as Administrator
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "⚠️ Please run this script as Administrator."
    Exit
}

Write-Host "🚀 Starting Docker Desktop installation..." -ForegroundColor Cyan

# Step 1: Set download path
$DownloadPath = "$env:TEMP\DockerDesktopInstaller.exe"

# Step 2: Download Docker Desktop Installer
Write-Host "📥 Downloading Docker Desktop installer..."
Invoke-WebRequest -UseBasicParsing -Uri "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe" -OutFile $DownloadPath

# Step 3: Run the installer
Write-Host "⚙️ Running Docker Desktop installer..."
Start-Process -FilePath $DownloadPath -Wait

# Step 4: Remove installer after installation
Remove-Item $DownloadPath -Force

Write-Host "✅ Docker Desktop installation completed!"
Write-Host "💡 Please restart your computer to complete the setup."
