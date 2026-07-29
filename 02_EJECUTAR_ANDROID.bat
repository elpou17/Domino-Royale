@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Domino Royale - Ejecutar Android

where flutter >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Flutter no esta agregado al PATH.
  pause
  exit /b 1
)

if not exist "android\gradlew.bat" call "%CD%\01_PREPARAR_PROYECTO.bat"
if errorlevel 1 exit /b 1

call flutter devices
echo.
echo Abre un emulador o conecta un celular con Depuracion USB.
call flutter run
if errorlevel 1 (
  echo [ERROR] No se pudo ejecutar la aplicacion.
  pause
  exit /b 1
)
