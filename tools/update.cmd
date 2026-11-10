@echo off
REM Wrapper: menjalankan update.ps1 tanpa terhalang ExecutionPolicy.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0update.ps1" %*
pause
