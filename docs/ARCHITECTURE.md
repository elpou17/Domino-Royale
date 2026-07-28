# Arquitectura técnica

## Decisión

Flutter permite mantener una sola base de código para Android, iOS y Web, trabajar desde VS Code y producir APK/AAB/IPA. El MVP usa arquitectura por funcionalidades con capas de dominio, aplicación y presentación.

## Límites

- El motor local es determinista y testeable.
- La interfaz no conoce detalles de persistencia ni proveedores de identidad.
- En producción, toda partida online debe validarse en un servidor autoritativo.
- Monedas, resultados y rankings nunca deben confiar en el cliente.

## Backend recomendado para fase online

- NestJS o Spring Boot.
- WebSocket para mesas en tiempo real.
- PostgreSQL para cuentas, partidas, economía y auditoría.
- Redis para presencia, matchmaking y estados efímeros.
- Firebase Auth como proveedor de identidad inicial.
- OpenTelemetry, logs estructurados y alertas.
