@echo off
REM Wrapper: menjalankan push.ps1 tanpa terhalang ExecutionPolicy.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0push.ps1" %*
pause
