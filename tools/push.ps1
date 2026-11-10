# Kirim perubahan yang Anda buat (di VS Code) ke GitHub, supaya agent bisa melihatnya.
# Pakai: .\tools\push.ps1 "pesan commit"

param([string]$Message = "update")

Set-Location (Split-Path -Parent $PSScriptRoot)

git add -A
git commit -m $Message
git push

Write-Host "Terkirim ke GitHub." -ForegroundColor Green
