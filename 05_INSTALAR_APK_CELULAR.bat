@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "APK=%CD%\build\app\outputs\flutter-apk\app-debug.apk"

if not exist "%APK%" (
  echo No existe app-debug.apk. Compilandolo ahora...
  call "%CD%\00_COMPILAR_APK_DEBUG.bat"
  if errorlevel 1 exit /b 1
)

where adb >nul 2>&1
if errorlevel 1 (
  echo [ERROR] adb no esta agregado al PATH.
  echo Agrega Android SDK platform-tools al PATH.
  pause
  exit /b 1
)

adb devices
adb install -r "%APK%"
if errorlevel 1 (
  echo [ERROR] No se pudo instalar. Activa Depuracion USB y acepta la autorizacion.
  pause
  exit /b 1
)
echo [OK] Domino Royale instalado.
pause
