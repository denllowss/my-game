@echo off
REM Wrapper: menjalankan autopull.ps1 tanpa terhalang ExecutionPolicy.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0autopull.ps1" %*
pause
