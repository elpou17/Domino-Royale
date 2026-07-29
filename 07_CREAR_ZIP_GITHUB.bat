@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "OUTPUT=%~dp0..\Domino-Royale-v2.0.0-GitHub.zip"
if exist "%OUTPUT%" del /q "%OUTPUT%"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$src='%CD%'; $out='%OUTPUT%';" ^
  "$items=Get-ChildItem -LiteralPath $src -Force | Where-Object { $_.Name -notin @('build','.dart_tool','.git','.idea') };" ^
  "Compress-Archive -Path $items.FullName -DestinationPath $out -Force"

if errorlevel 1 (
  echo [ERROR] No se pudo crear el ZIP.
  pause
  exit /b 1
)
echo [OK] ZIP creado: %OUTPUT%
pause
