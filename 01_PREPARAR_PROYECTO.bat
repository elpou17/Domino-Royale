@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Domino Royale - Preparar Proyecto

echo ============================================================
echo PREPARANDO DOMINO ROYALE

echo ============================================================
where flutter >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Flutter no esta agregado al PATH.
  pause
  exit /b 1
)

if not exist "android\gradlew.bat" (
  if exist android rmdir /s /q android
  call flutter create --platforms=android --org com.sudoticrd --project-name domino_royale .
  if errorlevel 1 goto :error
)
call powershell -NoProfile -ExecutionPolicy Bypass -File "%CD%\scripts\configurar_android.ps1"
if errorlevel 1 goto :error
call flutter clean
if errorlevel 1 goto :error
call flutter pub get
if errorlevel 1 goto :error
call flutter analyze --no-fatal-infos
if errorlevel 1 goto :error
call flutter test
if errorlevel 1 goto :error

echo [OK] Proyecto preparado y validado.
pause
exit /b 0

:error
echo [ERROR] No se pudo preparar el proyecto.
pause
exit /b 1
