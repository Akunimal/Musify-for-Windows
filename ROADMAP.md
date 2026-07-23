# Musify for Windows — Roadmap

## ✅ Completado
- [x] Toolchain (Flutter 3.44.6, VS Build Tools, CMake)
- [x] Windows platform files (CMakeLists, runner, plugins)
- [x] Adaptación de código Dart para Windows
- [x] CI/CD workflow (build + ZIP + release automático)
- [x] Release v10.1.1-port1 publicada
- [x] Iconos con Segoe Fluent Icons (nativos de Windows 11)

## 🎯 Corto plazo

### 1. Fondos animados que cambian con la música
Port de los 9 patrones Canvas desde PhoenixPowerCoder a Flutter:

| Patrón | Estado | Archivo (Flutter) |
|--------|--------|-------------------|
| Synapse | Pendiente | lib/widgets/background/synapse_painter.dart |
| Rain | Pendiente | lib/widgets/background/rain_painter.dart |
| Constellations | Pendiente | lib/widgets/background/constellations_painter.dart |
| Perlin Flow | Pendiente | lib/widgets/background/perlin_flow_painter.dart |
| Petals | Pendiente | lib/widgets/background/petals_painter.dart |
| Bubbles | Pendiente | lib/widgets/background/bubbles_painter.dart |
| Squares | Pendiente | lib/widgets/background/squares_painter.dart |
| Sparkles | Pendiente | lib/widgets/background/sparkles_painter.dart |
| Embers | Pendiente | lib/widgets/background/embers_painter.dart |

**Arquitectura propuesta:**
- `AnimatedBackground` (orquestador): elige patrón random al cambiar de canción
- Cada patrón es un `CustomPainter` con `AnimationController`
- Color se obtiene de `Theme.of(context).colorScheme.primary` o del color dominante del album art
- Intensidad variable según el estado (reproduciendo: más vivo, pausa: más tenue)

### 2. Temas desde PhoenixPowerCoder
Extraer los temas CSS del repo original y convertirlos a `ThemeData` de Flutter.
- Mapear variables CSS (`--bg`, `--fg`, `--accent`, etc.) a `ColorScheme`
- Crear ~5 temas ejemplo (claro, oscuro, high-contrast, etc.)
- Integrar con el selector de temas existente en Settings

## 🏗️ Mediano plazo
- [ ] Equalizador visual animado
- [ ] Mejoras de rendimiento (framerate adaptativo)
- [ ] Soporte de pantalla completa (Fullscreen)
- [ ] Atajos de teclado multimedia

## 🚀 Largo plazo
- [ ] Instalador MSI / winget
- [ ] Actualizaciones automáticas desde GitHub Releases
- [ ] Traducciones al español (y otros idiomas)
