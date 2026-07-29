@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Domino Royale - Firma Google Play

where keytool >nul 2>&1
if errorlevel 1 (
  echo [ERROR] keytool no esta disponible. Configura JDK 17 en JAVA_HOME.
  pause
  exit /b 1
)

set /p KEYPASS=Escribe una clave segura para el keystore: 
if "%KEYPASS%"=="" (
  echo [ERROR] La clave no puede estar vacia.
  pause
  exit /b 1
)

if not exist signing mkdir signing
keytool -genkeypair -v -keystore signing\domino-royale-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias domino_royale -storepass "%KEYPASS%" -keypass "%KEYPASS%" -dname "CN=Domino Royale, OU=Nexo Games, O=SudoTicRD, L=Santo Domingo, ST=DN, C=DO"
if errorlevel 1 goto :error

if not exist android (
  echo Ejecuta primero 01_PREPARAR_PROYECTO.bat.
  pause
  exit /b 1
)

(
  echo storePassword=%KEYPASS%
  echo keyPassword=%KEYPASS%
  echo keyAlias=domino_royale
  echo storeFile=../signing/domino-royale-upload.jks
) > android\key.properties

echo.
echo [OK] Keystore creado y key.properties generado.
echo IMPORTANTE: Guarda signing\domino-royale-upload.jks en un lugar seguro.
pause
exit /b 0

:error
echo [ERROR] No se pudo crear el keystore.
pause
exit /b 1
