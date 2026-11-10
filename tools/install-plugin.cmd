@echo off
REM Wrapper: menjalankan install-plugin.ps1 tanpa terhalang ExecutionPolicy.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-plugin.ps1" %*
pause
