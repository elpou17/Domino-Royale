@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Domino Royale - Compilar APK Debug

echo ============================================================
echo DOMINO ROYALE v2.0.2 - CONFIGURAR Y COMPILAR APK DEBUG
echo ============================================================

where flutter >nul 2>&1
if errorlevel 1 goto :no_flutter

where java >nul 2>&1
if errorlevel 1 goto :no_java

call :ensure_android
if errorlevel 1 goto :error
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
call flutter build apk --debug
if errorlevel 1 goto :error

set "APK=%CD%\build\app\outputs\flutter-apk\app-debug.apk"
if not exist "%APK%" goto :error

echo.
echo ============================================================
echo [OK] APK DEBUG GENERADO CORRECTAMENTE
echo %APK%
echo ============================================================
start "" "%CD%\build\app\outputs\flutter-apk"
pause
exit /b 0

:ensure_android
if exist "android\gradlew.bat" if exist "android\app\src\main\res\mipmap-mdpi\ic_launcher.png" exit /b 0
echo.
echo [INFO] Generando una plataforma Android completa y compatible...
if exist android rmdir /s /q android
call flutter create --platforms=android --org com.sudoticrd --project-name domino_royale .
if errorlevel 1 exit /b 1
call powershell -NoProfile -ExecutionPolicy Bypass -File "%CD%\scripts\configurar_android.ps1"
if errorlevel 1 exit /b 1
exit /b 0

:no_flutter
echo [ERROR] Flutter no esta instalado o no esta agregado al PATH.
echo Ejecuta flutter doctor desde una terminal nueva.
pause
exit /b 1

:no_java
echo [ERROR] Java no esta instalado o no esta agregado al PATH.
echo Instala Android Studio con JDK 17 o configura JAVA_HOME.
pause
exit /b 1

:error
echo.
echo ============================================================
echo [ERROR] LA COMPILACION NO TERMINO
echo Revisa la primera linea que diga ERROR o FAILURE.
echo ============================================================
pause
exit /b 1
