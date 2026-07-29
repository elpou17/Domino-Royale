@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Domino Royale - AAB Play Store

where flutter >nul 2>&1
if errorlevel 1 goto :error
if not exist "android\gradlew.bat" call "%CD%\01_PREPARAR_PROYECTO.bat"
if errorlevel 1 goto :error

if not exist "android\key.properties" (
  echo [ADVERTENCIA] No existe android\key.properties.
  echo Se generara un AAB de prueba usando la configuracion actual.
  echo Para publicar usa 08_CONFIGURAR_FIRMA_PLAYSTORE.bat.
  echo.
)

call flutter clean
if errorlevel 1 goto :error
call flutter pub get
if errorlevel 1 goto :error
call flutter analyze --no-fatal-infos
if errorlevel 1 goto :error
call flutter test
if errorlevel 1 goto :error
call flutter build appbundle --release
if errorlevel 1 goto :error

echo [OK] AAB GENERADO:
echo %CD%\build\app\outputs\bundle\release\app-release.aab
start "" "%CD%\build\app\outputs\bundle\release"
pause
exit /b 0

:error
echo [ERROR] No se pudo generar el AAB.
pause
exit /b 1
