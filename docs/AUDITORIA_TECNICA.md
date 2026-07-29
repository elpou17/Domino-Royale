# Auditoría técnica v2.0.0

## Fallo identificado en v1.1.0

El manifiesto referenciaba `@mipmap/ic_launcher`, pero las carpetas mipmap estaban vacías. También faltaban archivos esenciales generados por Flutter, incluyendo `gradlew`, `gradlew.bat`, `gradle-wrapper.jar`, `MainActivity.kt`, recursos de lanzamiento y configuraciones completas.

## Estrategia aplicada

La plataforma Android se genera mediante `flutter create` en la computadora del desarrollador. Esto alinea automáticamente Gradle, Android Gradle Plugin, Kotlin y el SDK con la versión estable de Flutter instalada y evita advertencias por versiones fijadas manualmente.

## Alcance real

El proyecto es un MVP local ejecutable. La autenticación social real, multijugador online, backend autoritativo, WebSockets, chat, ranking, torneos, economía, compras, publicidad, moderación y panel administrativo siguen pendientes de implementación.
