# Ambil perubahan terbaru dari GitHub (yang dibuat agent) lalu sync ke Studio.
# Pakai: .\tools\update.ps1

$ErrorActionPreference = "Stop"
Set-Location (Split-Path -Parent $PSScriptRoot)

if (-not (Test-Path ".git")) {
    Write-Host "Folder ini belum jadi git repo. Jalankan setup dulu (lihat SYNC-SETUP.md)." -ForegroundColor Red
    exit 1
}

Write-Host ">> git pull..." -ForegroundColor Cyan
git pull --rebase --autostash

if ($LASTEXITCODE -ne 0) {
    Write-Host "Pull gagal. Ada konflik lokal? Cek 'git status'." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Selesai. Kalau 'rojo serve' sedang jalan, Studio sudah ter-update." -ForegroundColor Green
