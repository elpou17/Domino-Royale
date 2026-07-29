@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Domino Royale - Reparar y Compilar

echo ============================================================
echo DOMINO ROYALE v2.0.2 - REPARACION INTEGRAL Y APK DEBUG
echo ============================================================

where flutter >nul 2>&1
if errorlevel 1 goto :no_flutter

if not exist "android\gradlew.bat" (
  echo [INFO] Generando plataforma Android con tu Flutter instalado...
  if exist android rmdir /s /q android
  call flutter create --platforms=android --org com.sudoticrd --project-name domino_royale .
  if errorlevel 1 goto :error
)

call powershell -NoProfile -ExecutionPolicy Bypass -File "%CD%\scripts\configurar_android.ps1"
if errorlevel 1 goto :error

if exist "test\widget_test.dart" (
  findstr /C:"DominoRoyaleApp" "test\widget_test.dart" >nul
  if errorlevel 1 (
    echo [ERROR] widget_test.dart no fue reparado correctamente.
    goto :error
  )
)

call flutter clean
if errorlevel 1 goto :error
call flutter pub get
if errorlevel 1 goto :error
call dart format lib test
if errorlevel 1 goto :error
call flutter analyze --no-fatal-infos
if errorlevel 1 goto :error
call flutter test
if errorlevel 1 goto :error
call flutter build apk --debug
if errorlevel 1 goto :error

set "APK=%CD%\build\app\outputs\flutter-apk\app-debug.apk"
if not exist "%APK%" goto :error

echo.
echo ============================================================
echo [OK] APK GENERADO CORRECTAMENTE
echo %APK%
echo ============================================================
start "" "%CD%\build\app\outputs\flutter-apk"
pause
exit /b 0

:no_flutter
echo [ERROR] Flutter no esta instalado o no esta agregado al PATH.
echo Ejecuta flutter doctor en una terminal nueva.
pause
exit /b 1

:error
echo.
echo ============================================================
echo [ERROR] LA REPARACION O COMPILACION NO TERMINO
echo Copia desde la primera linea ERROR o FAILURE y enviala.
echo ============================================================
pause
exit /b 1
