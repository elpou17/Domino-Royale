@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Domino Royale - Validar Codigo

where flutter >nul 2>&1
if errorlevel 1 goto :error

call flutter pub get
if errorlevel 1 goto :error
call dart format lib test
if errorlevel 1 goto :error
call flutter analyze --no-fatal-infos
if errorlevel 1 goto :error
call flutter test
if errorlevel 1 goto :error

echo ============================================================
echo [OK] CODIGO, ANALISIS Y PRUEBAS COMPLETADOS
echo ============================================================
pause
exit /b 0

:error
echo [ERROR] La validacion no termino. Revisa la primera linea roja.
pause
exit /b 1
