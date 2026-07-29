# Domino Royale v2.0.2 — Corrección de compilación

## Problema corregido
`flutter analyze` detenía los archivos `.bat` por cinco recomendaciones `prefer_const_constructors`. Estas recomendaciones eran informativas y no impedían generar el APK.

## Cambios
- Se agregaron constructores `const` donde correspondía.
- Se desactivó únicamente la regla informativa `prefer_const_constructors`.
- Todos los compiladores usan `flutter analyze --no-fatal-infos`.
- Los errores y advertencias reales continúan deteniendo la compilación.
- La versión fue actualizada a `2.0.2+8`.

## Compilación
Ejecutar `00_REPARAR_Y_COMPILAR.bat`.
