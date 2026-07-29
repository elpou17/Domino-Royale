@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Domino Royale - APK Release

where flutter >nul 2>&1
if errorlevel 1 goto :error
if not exist "android\gradlew.bat" call "%CD%\01_PREPARAR_PROYECTO.bat"
if errorlevel 1 goto :error

call flutter clean
if errorlevel 1 goto :error
call flutter pub get
if errorlevel 1 goto :error
call flutter analyze --no-fatal-infos
if errorlevel 1 goto :error
call flutter test
if errorlevel 1 goto :error
call flutter build apk --release
if errorlevel 1 goto :error

echo [OK] APK RELEASE:
echo %CD%\build\app\outputs\flutter-apk\app-release.apk
start "" "%CD%\build\app\outputs\flutter-apk"
pause
exit /b 0

:error
echo [ERROR] No se pudo generar el APK release.
pause
exit /b 1
