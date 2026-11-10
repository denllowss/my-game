# Auto-pull tiap 20 detik, supaya perubahan dari agent masuk tanpa Anda klik apa pun.
# Jalankan di terminal TERPISAH dari 'rojo serve':
#   .\tools\autopull.ps1

Set-Location (Split-Path -Parent $PSScriptRoot)

Write-Host "Auto-pull aktif. Ctrl+C untuk berhenti." -ForegroundColor Cyan
while ($true) {
    git pull --rebase --autostash 2>&1 | Out-Null
    Start-Sleep -Seconds 20
}
