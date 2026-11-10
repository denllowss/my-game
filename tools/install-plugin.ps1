# Pasang plugin Rojo ke Roblox Studio secara MANUAL.
# Dipakai kalau `rojo plugin install` gagal dengan pesan:
#   "Couldn't find registry keys, Roblox might not be installed"
# (Rojo mencari Studio lewat registry; cara ini mencari langsung ke folder disk.)
#
# Pakai:  .\tools\install-plugin.ps1

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$pluginSource = Join-Path $root "tools\plugin\Rojo.rbxm"

if (-not (Test-Path $pluginSource)) {
    Write-Host "File plugin tidak ada: $pluginSource" -ForegroundColor Red
    Write-Host "Download dari: https://github.com/rojo-rbx/rojo/releases/latest" -ForegroundColor Yellow
    exit 1
}

# --- 1. Cari Roblox Studio di disk -----------------------------------------
$candidates = @(
    "$env:LOCALAPPDATA\Roblox\Versions",
    "$env:ProgramFiles\Roblox\Versions",
    "${env:ProgramFiles(x86)}\Roblox\Versions",
    "$env:LOCALAPPDATA\Programs\Roblox\Versions"
) | Where-Object { $_ -and (Test-Path $_) }

$studios = @()
foreach ($dir in $candidates) {
    $studios += Get-ChildItem -Path $dir -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName "RobloxStudioBeta.exe") }
}

if (-not $studios -or $studios.Count -eq 0) {
    Write-Host "Roblox Studio tidak ditemukan di folder standar." -ForegroundColor Red
    Write-Host "Lokasi yang dicek:" -ForegroundColor Yellow
    $candidates | ForEach-Object { Write-Host "  $_" }
    Write-Host ""
    Write-Host "Solusi: buka Roblox Studio -> tab Plugins -> tombol 'Plugins Folder'," -ForegroundColor Cyan
    Write-Host "lalu copy manual file ini ke folder tersebut:" -ForegroundColor Cyan
    Write-Host "  $pluginSource" -ForegroundColor White
    exit 1
}

# Ambil versi terbaru (tanggal modifikasi paling baru)
$studio = $studios | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Write-Host "Studio ditemukan: $($studio.FullName)" -ForegroundColor Green

# --- 2. Tentukan folder Plugins --------------------------------------------
$pluginsDir = Join-Path (Split-Path -Parent $studio.FullName) "Plugins"
if (-not (Test-Path $pluginsDir)) {
    New-Item -ItemType Directory -Path $pluginsDir -Force | Out-Null
    Write-Host "Folder Plugins dibuat: $pluginsDir" -ForegroundColor Green
}

# --- 3. Copy plugin ---------------------------------------------------------
$target = Join-Path $pluginsDir "RojoManagedPlugin.rbxm"
Copy-Item $pluginSource $target -Force
Write-Host "Plugin terpasang: $target" -ForegroundColor Green
Write-Host ""
Write-Host "Sekarang TUTUP dan buka ulang Roblox Studio." -ForegroundColor Cyan
Write-Host "Tombol 'Rojo' akan muncul di tab Plugins." -ForegroundColor Cyan
