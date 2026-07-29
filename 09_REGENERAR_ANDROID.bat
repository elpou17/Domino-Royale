@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Domino Royale - Regenerar Android

where flutter >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Flutter no esta agregado al PATH.
  pause
  exit /b 1
)

choice /M "Se eliminara y regenerara la carpeta android. Deseas continuar"
if errorlevel 2 exit /b 0

if exist android rmdir /s /q android
call flutter create --platforms=android --org com.sudoticrd --project-name domino_royale .
if errorlevel 1 goto :error
call powershell -NoProfile -ExecutionPolicy Bypass -File "%CD%\scripts\configurar_android.ps1"
if errorlevel 1 goto :error
call flutter pub get
if errorlevel 1 goto :error

echo [OK] Android fue regenerado con la version instalada de Flutter.
pause
exit /b 0

:error
echo [ERROR] No se pudo regenerar Android.
pause
exit /b 1
