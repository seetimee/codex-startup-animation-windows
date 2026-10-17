@echo off
cd /d "%~dp0"
if not exist "%~dp0CodexStartup.exe" (
  echo 当前目录不是仓库根目录。请进入能看到 CodexStartup.exe 的文件夹后再运行。
  pause
  exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"
if errorlevel 1 pause
