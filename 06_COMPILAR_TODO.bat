@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Domino Royale - Compilar Todo

call "%CD%\01_PREPARAR_PROYECTO.bat"
if errorlevel 1 goto :error

call flutter build apk --debug
if errorlevel 1 goto :error
call flutter build apk --release
if errorlevel 1 goto :error
call flutter build appbundle --release
if errorlevel 1 goto :error

echo ============================================================
echo [OK] ARTEFACTOS GENERADOS
echo Debug:   build\app\outputs\flutter-apk\app-debug.apk
echo Release: build\app\outputs\flutter-apk\app-release.apk
echo AAB:     build\app\outputs\bundle\release\app-release.aab
echo ============================================================
start "" "%CD%\build\app\outputs"
pause
exit /b 0

:error
echo [ERROR] La compilacion se detuvo.
pause
exit /b 1
