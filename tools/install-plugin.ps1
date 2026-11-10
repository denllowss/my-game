# Pasang plugin Rojo ke Roblox Studio secara MANUAL.
#
# Dipakai kalau `rojo plugin install` gagal dengan pesan:
#   "Couldn't find registry keys, Roblox might not be installed"
# (Rojo mencari Studio lewat registry; script ini mencari langsung ke disk.)
#
# FOLDER TUJUAN YANG BENAR:
#   %LOCALAPPDATA%\Roblox\Plugins\RojoManagedPlugin.rbxm
# BUKAN ...\Roblox\Versions\Plugins  (Studio tidak membaca folder itu)
#
# Pakai:  .\tools\install-plugin.ps1

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$pluginSource = Join-Path $root "tools\plugin\Rojo.rbxm"

if (-not (Test-Path $pluginSource)) {
    Write-Host "File plugin tidak ada: $pluginSource" -ForegroundColor Red
    Write-Host "Jalankan 'git pull' dulu, atau unduh dari:" -ForegroundColor Yellow
    Write-Host "https://github.com/rojo-rbx/rojo/releases/latest" -ForegroundColor Yellow
    exit 1
}

Write-Host "Sumber plugin: $pluginSource" -ForegroundColor Gray
Write-Host ""

# --- 1. Deteksi Roblox Studio (informatif saja) -----------------------------
$candidates = @(
    "$env:LOCALAPPDATA\Roblox\Versions",
    "$env:ProgramFiles\Roblox\Versions",
    "${env:ProgramFiles(x86)}\Roblox\Versions",
    "$env:LOCALAPPDATA\Programs\Roblox\Versions"
) | Where-Object { $_ -and (Test-Path $_) }

$found = @()
foreach ($dir in $candidates) {
    $found += Get-ChildItem -Path $dir -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName "RobloxStudioBeta.exe") }
}

if ($found.Count -gt 0) {
    $studio = $found | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    Write-Host "Studio ditemukan: $($studio.FullName)" -ForegroundColor Green
} else {
    Write-Host "Studio tidak terdeteksi di folder standar (mungkin versi Microsoft Store)." -ForegroundColor Yellow
    Write-Host "Plugin tetap akan dipasang ke folder plugin standar Roblox." -ForegroundColor Yellow
}

# --- 2. Copy ke folder plugin yang BENAR -----------------------------------
# Roblox Studio membaca plugin lokal dari %LOCALAPPDATA%\Roblox\Plugins
$destinations = @(
    "$env:LOCALAPPDATA\Roblox\Plugins"
)

# Cadangan: kalau ada instalasi alternatif, pasang juga di sana (tidak berbahaya)
if ($env:PROGRAMFILES) {
    $destinations += "$env:PROGRAMFILES\Roblox\Plugins"
}

$installed = $false
foreach ($dest in $destinations) {
    try {
        New-Item -ItemType Directory -Force -Path $dest | Out-Null
        $target = Join-Path $dest "RojoManagedPlugin.rbxm"
        Copy-Item $pluginSource $target -Force
        $size = (Get-Item $target).Length
        Write-Host "Terpasang: $target ($size bytes)" -ForegroundColor Green
        if ($dest -like "$env:LOCALAPPDATA*") { $installed = $true }
    } catch {
        Write-Host "Gagal menulis ke ${dest}: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }
}

# --- 3. Bersihkan salah tempat dari versi script sebelumnya ----------------
$wrongDirs = Get-ChildItem "$env:LOCALAPPDATA\Roblox\Versions" -Directory -ErrorAction SilentlyContinue |
    ForEach-Object { Join-Path $_.FullName "Plugins" } |
    Where-Object { Test-Path (Join-Path $_ "RojoManagedPlugin.rbxm") }

foreach ($wrong in $wrongDirs) {
    Remove-Item (Join-Path $wrong "RojoManagedPlugin.rbxm") -Force -ErrorAction SilentlyContinue
    Write-Host "Dibersihkan (salah tempat): $wrong" -ForegroundColor DarkGray
}

Write-Host ""
if ($installed) {
    Write-Host "SELESAI. Sekarang TUTUP total Roblox Studio, lalu buka lagi." -ForegroundColor Cyan
    Write-Host "Tombol 'Rojo' akan muncul di tab Plugins." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Kalau tetap tidak muncul: di Studio buka tab Plugins -> 'Plugins Folder'," -ForegroundColor Yellow
    Write-Host "folder itu harus sama dengan: $env:LOCALAPPDATA\Roblox\Plugins" -ForegroundColor Yellow
} else {
    Write-Host "Plugin tidak bisa ditulis ke folder utama. Coba jalankan PowerShell sebagai Administrator," -ForegroundColor Red
    Write-Host "atau copy manual: buka Studio -> tab Plugins -> 'Plugins Folder'," -ForegroundColor Red
    Write-Host "lalu salin file ini ke folder tersebut dengan nama RojoManagedPlugin.rbxm:" -ForegroundColor Red
    Write-Host "  $pluginSource" -ForegroundColor White
}
