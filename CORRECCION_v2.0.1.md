# Corrección v2.0.1

Se corrigió el error de tipos en `showDailyBonusDialog`.

## Error corregido

`store.claimDailyBonus(profile)` devuelve `Future<PlayerProfile>`, mientras que la rama alternativa devolvía directamente `PlayerProfile`. El operador ternario infería `Object`, provocando `return_of_invalid_type_from_function`.

## Solución

Se sustituyó el ternario por una condición explícita que retorna correctamente el futuro o el perfil actual.

## Compilación

Ejecutar `00_REPARAR_Y_COMPILAR.bat`.
