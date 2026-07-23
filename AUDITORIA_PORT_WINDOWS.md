# Auditoría de Portabilidad Android → Windows

**Proyecto:** Musify
**Fecha:** 2026-07-23
**Propósito:** Identificar problemas de portabilidad en migración de Android a Windows.
**Alcance:** 8 áreas auditadas en paralelo. Cada hallazgo verificado contra código fuente.

---

## Resumen

| Área | Archivos Revisados | Crítico | Alto | Medio | Bajo |
|------|----|---------|------|-------|------|
| Assets e iconos | 33 | 0 | 1 | 3 | 3 |
| NAVEGACION Y FLUJOS | 19 | 1 | 2 | 4 | 3 |
| Portabilidad Android a Windows (APIs de Plataforma) | 30 | 2 | 1 | 0 | 9 |
| SISTEMA DE ARCHIVOS Y RUTAS | 20 | 2 | 2 | 4 | 3 |
| CICLO DE VIDA Y ESTADO | 19 | 1 | 4 | 4 | 1 |
| INPUT Y EVENTOS - portabilidad Android a Windows | 35 | 3 | 4 | 3 | 2 |
| LAYOUT Y DIMENSIONES - Portabilidad Android a Windows | 8 | 0 | 2 | 4 | 1 |
| Portabilidad Android a Windows - BUILD, DEPENDENCIAS Y CONFIGURACION | 34 | 1 | 2 | 6 | 4 |
| **Total** | **198** | **10** | **18** | **28** | **26** |

---

## Assets e Iconos (re-ejecutado)

**Archivos revisados (33):**

- `C:\Extension\Musify\pubspec.yaml`
- `C:\Extension\Musify\assets\icons\musify_icon.png`
- `C:\Extension\Musify\assets\fonts\segoe\SegoeFluentIcons.ttf`
- `C:\Extension\Musify\assets\fonts\paytone\PaytoneOne-Regular.ttf`
- `C:\Extension\Musify\assets\licenses\paytone.txt`
- `C:\Extension\Musify\windows\runner\resources\app_icon.ico`
- `C:\Extension\Musify\windows\runner\Runner.rc`
- `C:\Extension\Musify\windows\runner\resource.h`
- `C:\Extension\Musify\lib\main.dart`
- `C:\Extension\Musify\lib\main_fdroid.dart`
- `C:\Extension\Musify\lib\utilities\app_icon.dart`
- `C:\Extension\Musify\lib\theme\app_themes.dart`
- `C:\Extension\Musify\lib\theme\dynamic_color_compat.dart`
- `C:\Extension\Musify\lib\widgets\song_artwork.dart`
- `C:\Extension\Musify\lib\widgets\playlist_artwork.dart`
- `C:\Extension\Musify\lib\widgets\no_artwork_cube.dart`
- `C:\Extension\Musify\lib\widgets\now_playing\now_playing_artwork.dart`
- `C:\Extension\Musify\lib\utilities\artwork_provider.dart`
- `C:\Extension\Musify\android\app\src\main\res\drawable-hdpi`
- `C:\Extension\Musify\android\app\src\main\res\drawable-mdpi`
- `C:\Extension\Musify\android\app\src\main\res\drawable-xhdpi`
- `C:\Extension\Musify\android\app\src\main\res\drawable-xxhdpi`
- `C:\Extension\Musify\android\app\src\main\res\drawable-xxxhdpi`
- `C:\Extension\Musify\android\app\src\main\res\drawable`
- `C:\Extension\Musify\android\app\src\main\res\drawable-night`
- `C:\Extension\Musify\android\app\src\main\res\drawable-night-v21`
- `C:\Extension\Musify\android\app\src\main\res\drawable-v21`
- `C:\Extension\Musify\android\app\src\main\res\mipmap-anydpi-v26`
- `C:\Extension\Musify\android\app\src\main\res\mipmap-hdpi`
- `C:\Extension\Musify\android\app\src\main\res\mipmap-mdpi`
- `C:\Extension\Musify\android\app\src\main\res\mipmap-xhdpi`
- `C:\Extension\Musify\android\app\src\main\res\mipmap-xxhdpi`
- `C:\Extension\Musify\android\app\src\main\res\mipmap-xxxhdpi`

##### assets/placeholder.png referenciado en codigo NO existe en disco
- **Severidad:** alto
- **Archivo:** `C:\Extension\Musify\lib\utilities\artwork_provider.dart`:57
- **Codigo:**
```dart
provider = const AssetImage('assets/placeholder.png');
```
- **Descripcion:** El metodo estatico ArtworkProvider.get() usa AssetImage('assets/placeholder.png') como fallback cuando falla la resolucion de una URL/URI de artwork. Sin embargo, el archivo 'assets/placeholder.png' NO existe en el sistema de archivos del proyecto (no aparece en ningun glob ni en assets/). Esto provoca una segunda excepcion dentro del catch, silenciada porque esta fuera del try, que hara que el widget Image (en PlaylistArtwork) lance un error no capturado y muestre un broken-image en tiempo de ejecucion.
- **Reproduccion:** 1. Llamar a ArtworkProvider.get() con un string que no sea http://, data:image, file:// ni / (ej. un string vacio o un nombre invalido). 2. El catch de la linea 56 captura el primer error. 3. Dentro del catch se ejecuta AssetImage('assets/placeholder.png'). 4. Flutter no encuentra el asset porque no existe en disco y no esta declarado en pubspec.yaml, lanzando un FlutterError. 5. El widget Image en playlist_artwork.dart linea 60-66 recibe un provider invalido y muestra error.
- **Test:** Si (test_unitario)
- **Correccion:** Crear el archivo assets/placeholder.png en el directorio de assets, o reemplazar la referencia por un fallback que no requiera asset (como un MemoryImage con un buffer generado programaticamente, o un fallback que devuelva null y se maneje en el caller).

##### pageTransitionsTheme solo define transicion para Android, no para Windows
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\lib\theme\app_themes.dart`:263-266
- **Codigo:**
```dart
pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: transitionsBuilder,
      },
    ),
```
- **Descripcion:** El PageTransitionsTheme solo registra un PageTransitionsBuilder para TargetPlatform.android. En Windows (y otros destkop como macOS, Linux), Flutter usara la transicion por defecto (FadeUpwardsPageTransitionsBuilder) en lugar del CupertinoPageTransitionsBuilder o PredictiveBackPageTransitionsBuilder que el usuario haya configurado. Esto rompe la consistencia UX: en Windows las transiciones entre pantallas seran diferentes a las de Android, usando la animacion por defecto de Flutter en lugar de la disenada.
- **Reproduccion:** 1. Ejecutar la app en Windows. 2. Navegar entre pantallas (ej. Home -> Search -> Library). 3. Observar que la animacion de transicion es la default de Flutter (fade-upwards) en lugar de la transicion Cupertino slide que se usa en Android.
- **Test:** Si (test_widget)
- **Correccion:** Agregar TargetPlatform.windows (y otros desktop) al mapa builders. Ejemplo: builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: transitionsBuilder,
        TargetPlatform.windows: transitionsBuilder,
        TargetPlatform.linux: transitionsBuilder,
        TargetPlatform.macOS: transitionsBuilder,
      }

##### androidNotificationIcon usa ruta drawable de Android sin equivalente Windows
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\lib\main.dart`:311
- **Codigo:**
```dart
androidNotificationIcon: 'drawable/ic_launcher_foreground',
```
- **Descripcion:** AudioServiceConfig especifica androidNotificationIcon usando una ruta de recurso Android ('drawable/ic_launcher_foreground'). En Windows, el sistema de notificaciones del audio_service no resuelve rutas drawable/ de Android. Aunque el parametro se llame 'androidNotificationIcon' (Android-only en teoria), si audio_service en Windows lo intenta resolver, fallara porque no existe un drawable folder en el build de Windows. La notificacion podria terminar sin icono o con un placeholder generico.
- **Reproduccion:** 1. Ejecutar la app en Windows. 2. Reproducir musica. 3. La notificacion del sistema (systray/notification center) mostrara un icono por defecto en lugar del icono de la app, o podria no mostrar notificacion si audio_service requiere un icono valido en Windows.
- **Test:** No (manual)
- **Correccion:** Proveer configuracion de icono para desktop/Windows en el AudioServiceConfig. En Windows, audio_service puede usar un icono por recurso (IDI_APP_ICON del .exe) o una ruta de archivo PNG. Agregar logica condicional: si Platform.isWindows, usar una ruta alternativa (por ejemplo, la ruta absoluta al .ico o un PNG dentro del bundle).

##### Comentario contradictorio en app_icon.dart: 'No custom fonts needed' pero el font se bundlea
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\lib\utilities\app_icon.dart`:3-5
- **Codigo:**
```dart
/// IconData constants using 'Segoe Fluent Icons' — the modern Windows 11
/// icon font built into every Windows 11 system. No custom fonts needed.
```
- **Descripcion:** El comentario de documentacion afirma 'No custom fonts needed' (no se necesitan fuentes personalizadas), pero en pubspec.yaml lineas 67-69 se declara y bundlea el archivo 'assets/fonts/segoe/SegoeFluentIcons.ttf' como un asset de fuente. Hay una contradiccion: si el font ya viene con Windows 11, no haria falta bundlearlo; si se bundlea, el comentario es incorrecto. Ademas, el archivo SegoeFluentIcons.ttf (464,816 bytes) es una fuente propietaria de Microsoft cuya redistribucion puede tener restricciones legales, y no hay un archivo de licencia para ella en assets/licenses/.
- **Reproduccion:** 1. Leer el comentario en app_icon.dart lineas 3-5. 2. Leer pubspec.yaml lineas 67-69 donde se declara el font asset. 3. Verificar que assets/licenses/ solo contiene paytone.txt, sin ninguna licencia para Segoe Fluent Icons.
- **Test:** No (manual)
- **Correccion:** Corregir el comentario para reflejar que el font se bundlea como fallback para compatibilidad con Windows 10/11. Agregar archivo de licencia para SegoeFluentIcons.ttf en assets/licenses/ si la licencia de Microsoft lo permite. Alternativamente, si el font no necesita ser redistribuido porque Windows ya lo provee, remover el font declarado de pubspec.yaml y agregar un fallback Material Icon por si el font del sistema no esta disponible.

##### app_icon.ico contiene PNG de 256x32bpp diferente al musify_icon.png fuente
- **Severidad:** bajo
- **Archivo:** `C:\Extension\Musify\windows\runner\resources\app_icon.ico`:N/A (archivo binario)
- **Codigo:**
```dart
ICO entry #1: 256x256, bpp=32, size=8542 bytes, offset=166
musify_icon.png: 2915 bytes
```
- **Descripcion:** El archivo app_icon.ico contiene una entrada PNG de 256x256 a 32bpp que pesa 8,542 bytes. El archivo fuente assets/icons/musify_icon.png pesa 2,915 bytes y es IDENTICO a android/app/src/main/res/drawable-xxxhdpi/ic_launcher_foreground.png. La diferencia de tamano (8542 vs 2915) indica que el ICO no fue generado automaticamente a partir del PNG fuente actual, sino que es un archivo independiente desactualizado. El timestamp del ICO (enero 2025) es anterior al del PNG (julio 2026). Si se actualizo el icono de la app, el .ico no refleja esos cambios.
- **Reproduccion:** 1. Comparar los bytes de la entrada 256x32bpp del ICO con musify_icon.png. 2. Verificar que son diferentes (el ICO entry es 8542B, el PNG es 2915B). 3. Si el icono de la app fue redisenado recientemente, el .exe compilado mostrara el icono antiguo.
- **Test:** No (manual)
- **Correccion:** Regenerar app_icon.ico a partir de musify_icon.png usando una herramienta como ImageMagick o png2ico, asegurando que todas las resoluciones (256x256, 48x48, 32x32, 16x16) y profundidades de color (32bpp, 8bpp, 4bpp) esten incluidas. Automatizar el proceso en un script de build.

##### 30 iconos de notificacion audio_service existen solo en Android, sin equivalente Windows
- **Severidad:** bajo
- **Archivo:** `C:\Extension\Musify\android\app\src\main\res\drawable-{hdpi,mdpi,xhdpi,xxhdpi,xxxhdpi}/audio_service_{pause,play_arrow,skip_next,skip_previous,stop}.png`:Multiples archivos (30 PNGs)
- **Codigo:**
```dart
drawable-hdpi/audio_service_pause.png, drawable-mdpi/audio_service_play_arrow.png, ..., drawable-xxxhdpi/audio_service_stop.png
```
- **Descripcion:** Android tiene 5 iconos de control de reproduccion para audio_service (pause, play_arrow, skip_next, skip_previous, stop) en 6 densidades (mdpi a xxxhdpi), total 30 archivos PNG. No existe ningun equivalente en la carpeta windows/ (ni .ico, .png ni .bmp). Si audio_service en Windows intenta usar estos iconos para notificaciones o control de reproduccion, no los encontrara. Sin embargo, el comportamiento exacto en Windows depende de la implementacion de just_audio_windows + audio_service, que posiblemente use los iconos del sistema o el icono de la app.
- **Reproduccion:** 1. Ejecutar la app en Windows. 2. Iniciar reproduccion. 3. Verificar si la notificacion de reproduccion muestra iconos de control (pause/play/skip). Si audio_service en Windows intenta cargar estos assets y no existen, los controles podrian faltar o verse como placeholders.
- **Test:** No (manual)
- **Correccion:** Verificar si audio_service + just_audio_windows necesita estos iconos en Windows. Si es necesario, convertir los PNGs Android a .ico o .png y colocarlos en windows/runner/resources/. Si el plugin usa iconos del sistema, documentar que no se requieren.

##### Android adaptive icons y background drawables sin equivalente Windows
- **Severidad:** bajo
- **Archivo:** `C:\Extension\Musify\android\app\src\main\res\mipmap-*/ y drawable-*/background.png`:Multiples archivos
- **Codigo:**
```dart
mipmap-anydpi-v26/ic_launcher.xml, mipmap-*/ic_launcher.png, mipmap-*/ic_launcher_adaptive_fore.png,
drawable-night/background.png, drawable-night-v21/background.png, drawable-v21/background.png, drawable/background.png
```
- **Descripcion:** Android posee un sistema completo de iconos adaptativos: 12 archivos mipmap para el launcher (ic_launcher.png + ic_launcher_adaptive_fore.png en 6 densidades) mas un XML de configuracion, y 4 variantes de background.png (base, night, v21, night-v21) para splash screen. En Windows esto se reemplaza por un unico archivo .ico (app_icon.ico) y la splash screen se maneja via flutter_window.cpp. La ausencia de equivalentes directos es normal por la diferencia de plataformas, pero vale la pena notar que el background.png de Android en sus variantes night es de solo 69 bytes (placeholder), lo que sugiere que tampoco en Android esta completamente implementado.
- **Reproduccion:** N/A - Diferencia de plataforma esperada.
- **Test:** No (manual)

---

## Layout y Dimensiones (re-ejecutado)

**Archivos revisados (8):**
- `windows/runner/main.cpp`
- `lib/screens/bottom_navigation_page.dart`
- `lib/screens/now_playing_page.dart`
- `lib/screens/home_page.dart`
- `lib/screens/playlist_page.dart`
- `lib/widgets/mini_player_bottom_space.dart`
- `lib/screens/search_page.dart`
- `lib/screens/artist_page.dart`

##### Ventana 1280x720 fija sin constraints min/max para redimension
- **Severidad:** alto
- **Archivo:** `windows/runner/main.cpp`:15-16
- **Código:**
```cpp
Win32Window::Size size(1280, 720);
if (!window.Create(L"musify", origin, size)) {
```
- **Descripción:** El tamaño inicial de la ventana es 1280x720 fijo (hardcodeado en C++). No se definen tamaños mínimo ni máximo vía WM_GETMINMAXINFO o SetWindowPos constraints. En Windows el usuario puede redimensionar libremente, pero sin restricciones mínimas la UI puede colapsar si se reduce demasiado. Tampoco se guarda/restaura la posición y tamaño entre sesiones.
- **Reproducción:** 1. Abrir Musify en Windows. 2. Redimensionar la ventana a menos de 400px de ancho. 3. Los elementos UI se superponen, el texto se corta, y algunos botones quedan fuera de la vista sin scroll.
- **Test:** Sí (test_automatizado_e2e)
- **Corrección:** Agregar handler WM_GETMINMAXINFO en win32_window.cpp para establecer MINTRACK (ej. 360x480). Opcionalmente guardar/restaurar tamaño con GetWindowPlacement/SetWindowPlacement en el registro.

##### SafeArea innecesario en 5 ubicaciones (asume notches Android)
- **Severidad:** alto
- **Archivo:** `lib/screens/bottom_navigation_page.dart`:85, `lib/screens/now_playing_page.dart`:45, `lib/screens/time_machine_page.dart`:335, `lib/widgets/mini_player_bottom_space.dart`:31,47
- **Código:**
```dart
body: SafeArea(
  child: Row( ... )
```
- **Descripción:** SafeArea se usa en 5 lugares para evitar notches/status bar de Android. En Windows no hay notches ni sistema de barras del sistema en la ventana de la app. SafeArea en Windows añade padding inecesario (típicamente 0 o 25px dependiendo del DPI) que reduce el espacio útil. Particularmente en mini_player_bottom_space.dart:31 y :47, SafeArea y SliverSafeArea envuelven un SizedBox(height: 0) — completamente redundante.
- **Reproducción:** 1. Abrir Musify en Windows. 2. Observar que el contenido tiene padding extra innecesario (especialmente en bottom_navigation_page y now_playing_page). 3. Comparar con el mismo contenido sin SafeArea: se desperdicia espacio vertical.
- **Test:** Sí (test_widget)
- **Corrección:** Envolver SafeArea con `if (Platform.isAndroid || Platform.isIOS)` o usar `SafeArea(left: false, right: false, top: false, bottom: false)` condicional. Para el SizedBox en mini_player_bottom_space.dart, eliminar SafeArea por completo (no aporta nada).

##### BouncingScrollPhysics en lugar de ClampingScrollPhysics en listas
- **Severidad:** medio
- **Archivo:** `lib/screens/search_page.dart`:310, `lib/screens/settings_page.dart`:629
- **Código:**
```dart
physics: const BouncingScrollPhysics(),
```
- **Descripción:** dos ubicaciones usan BouncingScrollPhysics (efecto de rebote iOS) en lugar de ClampingScrollPhysics (detención firme al borde, nativa de Android/Windows). En Windows el comportamiento de scroll por defecto (con rueda del mouse) es de detención firme. El rebote se siente antinatural.
- **Reproducción:** 1. Ir a Search page. 2. Hacer scroll con rueda del mouse al final. 3. El contenido rebota en vez de detenerse firmemente.
- **Test:** Sí (test_widget)
- **Corrección:** Cambiar a ClampingScrollPhysics en Windows para consistencia con la plataforma, o usar `ScrollConfiguration.of(context).physics` que hereda la física por defecto de la plataforma.

##### SizedBox con altura fija en toda la app sin proporcionalidad
- **Severidad:** medio
- **Archivo:** `lib/screens/about_page.dart`:41,56,65,90,117,130,143,161,182,195,209,220 (12 ocurrencias)
- **Código:**
```dart
const SizedBox(height: 14),
const SizedBox(width: 14),
```
- **Descripción:** En about_page.dart se usan 12 SizedBox con valores fijos (8, 12, 14, 16, 32) para separación visual. En una ventana redimensionable de Windows, los espaciados deberían escalar con el viewport. 14px en un monitor 4K es insignificante, pero 32px en una ventana pequeña desperdicia espacio. La ausencia de espaciado proporcional (Ej: MediaQuery.of(context).size.height * 0.02) hace que el layout no se adapte.
- **Reproducción:** 1. Abrir About page en Windows. 2. Redimensionar la ventana a distintos tamaños. 3. Las separaciones entre secciones son siempre las mismas independientemente del tamaño de la ventana.
- **Test:** Sí (test_widget)
- **Corrección:** Reemplazar SizedBox fijos con espaciado proporcional usando MediaQuery o LayoutBuilder. Alternativa: usar SizedBox(height: 0.02 * availableHeight) cuando sea apropiado.

##### Altura de pantalla calculada restando 100px fijos para scroll
- **Severidad:** medio
- **Archivo:** `lib/screens/artist_page.dart`:132, `lib/screens/playlist_page.dart`:210
- **Código:**
```dart
height: MediaQuery.sizeOf(context).height - 100,
```
- **Descripción:** Dos pantallas calculan la altura disponible como `viewportHeight - 100px` para dar espacio al header. El valor 100 es un guess fijo que funciona en pantallas de móvil (~360-480dp de ancho). En monitores Windows de alta resolución (1920x1080, 2560x1440), restar solo 100px deja demasiado espacio vacío; en ventanas muy pequeñas puede dejar espacio insuficiente.
- **Reproducción:** 1. Abrir Artist page en Windows. 2. Redimensionar la ventana a 800x600. 3. La altura del body es viewportHeight - 100 = ~460px, pero el header real puede ocupar más de 100px, causando overflow. 4. En ventana grande (1920x1080), el body es ~980px pero el layout estándar de lista no usa el espacio extra.
- **Test:** Sí (test_widget)
- **Corrección:** Usar LayoutBuilder para obtener constraints reales, o calcular altura del header dinámicamente y restar ese valor en lugar de 100 fijo.

##### No hay sidebar/drawer persistente para escritorio
- **Severidad:** medio
- **Archivo:** `lib/screens/bottom_navigation_page.dart` (ausencia de Drawer)
- **Código:** (Drawer no implementado para Windows)
- **Descripción:** La navegación usa BottomNavigationBar + GoRouter tabs, diseñado para móvil. En Windows, la convención es sidebar persistente (navigation rail) que no requiere tap para cambiar de sección y muestra labels siempre visibles. No hay implementación alternativa de NavigationRail o NavigationDrawer para desktop.
- **Reproducción:** 1. Abrir Musify en Windows. 2. Los tabs están en la parte inferior (como móvil). 3. No hay forma de ver el label de cada tab sin seleccionarlo. 4. En ventanas anchas, el espacio lateral está vacío.
- **Test:** Sí (test_widget)
- **Corrección:** Usar `if (isDesktop)` para cambiar a NavigationRail (sidebar izquierda) con labels visibles y hover states. El BottomNavigationBar se mantiene para móvil.

##### No hay manejo de keyboard focus/highlight en listas para navegación por teclado
- **Severidad:** bajo
- **Archivo:** `lib/screens/search_page.dart`, `lib/screens/playlist_page.dart` (Cards/Lists sin Focus)
- **Código:** (ausencia de Focus/ElevatedButton/Actions en items de lista)
- **Descripción:** Las listas de canciones, artistas y playlists no tienen manejo de foco visible para navegación por teclado (Tab, flechas). Los items son ListTile/InkWell sin FocusNode ni FocusDecoration. En Windows, los usuarios frecuentemente navegan con teclado.
- **Reproducción:** 1. Abrir Search en Windows. 2. Presionar Tab repetidamente. 3. El foco no se mueve por los resultados de búsqueda. 4. No se puede seleccionar un resultado con Enter.
- **Test:** Sí (test_automatizado_e2e)
- **Corrección:** Agregar FocusTraversalGroup y Focus a los items de lista. Usar actions: / Focus y onKeyEvent para manejar Enter/Escape.

---

## Hallazgos por Severidad

### Crítico (10)

#### NowPlayingPage fuera del arbol de GoRouter: stack de navegacion hibrido

- **Área:** NAVEGACION Y FLUJOS
- **Archivo:** `C:\Extension\Musify\lib\widgets\mini_player.dart` línea 147
- **Fragmento:** `Navigator.of(context).push(_createSlideTransition());`
- **Descripción:** NowPlayingPage se navega via Navigator.of(context).push() (Navigator raw) en vez de GoRouter. Mientras 16 pantallas se manejan con GoRouter y su StatefulShellRoute, NowPlayingPage queda fuera del arbol de rutas. Esto crea un stack hibrido: (1) no hay URL para NowPlayingPage, (2) no hay restauracion de estado GoRouter, (3) routerNeglect:true no aplica, (4) no hay deep linking a NowPlayingPage. El estado compartido via audioHandler singleton mitiga parcialmente pero no resuelve la perdida de estado de navegacion.
- **Reproducción:** 1. Tocar el mini player estando en Home tab. 2. Se abre NowPlayingPage. 3. La URL en GoRouter sigue siendo /home (no cambia). 4. Matar y reiniciar la app: NowPlayingPage no se restaura aunque hubiera una cancion sonando. 5. La transicion slide-up desde Navigator raw no tiene relacion con las transiciones fade+slide de GoRouter.
- **Detectable por test:** Sí (test_widget)

#### Process.run('uname', ['-m']) no existe en Windows: crashea getDownloadUrl

- **Área:** Portabilidad Android a Windows (APIs de Plataforma)
- **Archivo:** `lib/services/update_manager.dart` línea 257-261
- **Fragmento:** `Future<String> getCPUArchitecture() async {
  final info = await Process.run('uname', ['-m']);
  final cpu = info.stdout.toString().replaceAll('\n', '');
  return cpu;
}`
- **Descripción:** El comando `uname -m` es de UNIX/Linux. En Windows puro (cmd.exe, PowerShell) no existe, y aunque Git Bash lo tenga, Process.run lanza `cmd.exe` por defecto y no encuentra el binario. Esto lanza ProcessException y rompe todo el flujo de descarga de actualizaciones (update_manager.dart:263-265 getDownloadUrl llama a getCPUArchitecture).
- **Reproducción:** 1. Ejecutar en Windows. 2. Navegar a Settings > Updates > pulsar Download. 3. getDownloadUrl llama getCPUArchitecture -> Process.run('uname') lanza ProcessException:系統找不到指定的文件。. 4. La excepción sube al catch genérico de checkAppUpdates (linea 170) y solo se loggea, el dialogo de update se queda colgado.
- **Detectable por test:** Sí (test_unitario)
- **Corrección propuesta:** Reemplazar getCPUArchitecture con detección nativa Windows. Usar `dart:io` Platform.environment o Process.run('wmic', ['os', 'get', 'osarchitecture']) en Windows, o mejor aun, usar `dart:io` `Platform.operatingSystem` para detectar si es Windows a secas y asumir x64 (el APK siempre es x64 o aarch64). Alternativa: usar `dart:io` `ProcessInfo` o leer variable de entorno PROCESSOR_ARCHITECTURE.

#### AudioService.init sin fallback si el plugin Windows falla

- **Área:** Portabilidad Android a Windows (APIs de Plataforma)
- **Archivo:** `lib/main.dart` línea 306-315
- **Fragmento:** `audioHandler = await AudioService.init(
  builder: MusifyAudioHandler.new,
  config: const AudioServiceConfig(
    androidNotificationChannelId: 'com.gokadzev.musify',
    androidNotificationChannelName: 'Musify',
    androidNotificationIcon: 'drawable/ic_launcher_foreground',
    androidShowNotificationBadge: true,
    androidStopForegroundOnPause: false,
  ),
);`
- **Descripción:** AudioService.init() no está envuelto en try-catch individual. Si audio_service (v0.18.19) no tiene implementación Windows completa o registrada, lanza MissingPluginException. El catch general de initialisation() (linea 335) lo agarra, pero `audioHandler` (declarado late) queda sin inicializar. CUALQUIER acceso posterior a audioHandler (ej. en audio_service.dart, sharing_intent.dart, flutter_toast.dart) causa LateInitializationError en runtime.
- **Reproducción:** 1. Compilar y ejecutar en Windows sin que audio_service tenga backend nativo registrado. 2. initialisation falla en AudioService.init -> MissingPluginException. 3. catch general loggea el error pero audioHandler sigue late. 4. Cualquier interaccion UI que toque audioHandler (play, pause, next, miniplayer) explota con LateInitializationError.
- **Detectable por test:** Sí (test_integracion)
- **Corrección propuesta:** Envolver AudioService.init en try-catch especifico. Si falla, crear audioHandler manualmente (MusifyAudioHandler() directo) como fallback, y loggear el error. Evaluar migracion a media_kit como player primario en Windows si audio_service no madura.

#### getCPUArchitecture() usa 'uname -m' que no existe en Windows

- **Área:** SISTEMA DE ARCHIVOS Y RUTAS
- **Archivo:** `C:/Extension/Musify/lib/services/update_manager.dart` línea 256-261
- **Fragmento:** `Future<String> getCPUArchitecture() async { final info = await Process.run('uname', ['-m']); ... }`
- **Descripción:** El metodo getCPUArchitecture() ejecuta el comando Unix 'uname -m' para detectar la arquitectura del CPU. Este comando no existe en Windows. Process.run() lanzara una excepcion FileNotFoundException. La funcion getDownloadUrl() llama a getCPUArchitecture() para decidir entre downloadUrlKey y downloadUrlArm64Key (lines 263-268), por lo que las actualizaciones se rompen por completo en Windows.
- **Reproducción:** En Windows, getCPUArchitecture() ejecuta Process.run('uname', ['-m']). Como 'uname' no es un comando de Windows, Process.run() lanza una excepcion que burbujea hasta checkAppUpdates() donde es capturada por el catch generico en linea 169, resultando en que la actualizacion falla silenciosamente sin mostrar dialogo.
- **Detectable por test:** Sí (test_unitario)
- **Corrección propuesta:** Reemplazar getCPUArchitecture() con una implementacion multiplataforma usando 'dart:io' Platform.operatingSystem + Platform.numberOfProcessors o usar wmic/registry en Windows. En Windows, se puede usar 'echo %PROCESSOR_ARCHITECTURE%' o leer la variable de entorno. Alternativamente, simplificar: en Windows siempre descargar x64 (la mayoria de PCs Windows son x64).

#### downloadFilename hardcoded como 'Musify.apk' siempre

- **Área:** SISTEMA DE ARCHIVOS Y RUTAS
- **Archivo:** `C:/Extension/Musify/lib/services/update_manager.dart` línea 44
- **Fragmento:** `const String downloadFilename = 'Musify.apk';`
- **Descripción:** El nombre del archivo de descarga esta hardcodeado como 'Musify.apk' (extension Android). En Windows debe descargar un instalador .exe, .msix o .zip. La constante downloadFilename se declara pero nunca se usa en el codigo actual; sin embargo, su presencia indica que todo el modulo update_manager fue disenado exclusivamente para Android.
- **Reproducción:** En Windows, cuando checkAppUpdates() detecta una nueva version, llama a getDownloadUrl() que devuelve la URL del release de GitHub, y luego launchURL() abre el navegador. La URL apunta al release de GitHub que contiene assets para todas las plataformas, pero no hay logica para seleccionar el asset correcto para Windows.
- **Detectable por test:** No (manual)
- **Corrección propuesta:** Agregar deteccion de plataforma para seleccionar el asset correcto (Musify.msix, Musify.exe, etc) de los releases de GitHub. Usar Platform.isWindows para construir la URL del asset correcto.

#### Hive.close() en widget dispose() no se ejecuta al cerrar ventana Windows

- **Área:** CICLO DE VIDA Y ESTADO
- **Archivo:** `lib/main.dart` línea 221
- **Fragmento:** `Hive.close(); // Dentro de _MusifyState.dispose()`
- **Descripción:** El cierre de Hive solo ocurre en el metodo dispose() del widget raiz. En Windows, al cerrar la ventana (click en X), el proceso termina inmediatamente y dispose() de los widgets NO se invoca de forma confiable. Esto puede corromper las cajas Hive (settings, user, userNoBackup, cache) y perder datos de escucha en progreso.
- **Reproducción:** 1. Abrir Musify en Windows. 2. Reproducir musica. 3. Cerrar la ventana con el boton X. 4. Reabrir Musify. 5. Las cajas Hive pueden aparecer corruptas o la app crashea al intentar leer datos.
- **Detectable por test:** Sí (test_unitario)
- **Corrección propuesta:** Agregar un manejador de cierre en Windows usando dart:io ProcessSignal.sigterm o un callback en SystemChannels.lifecycle. Envolver Hive.close() dentro de un shutdown hook que se ejecute antes de que el proceso termine. Ejemplo: void main() { ... WidgetsFlutterBinding.ensureInitialized(); ... // Registrar shutdown hook try { final exitHandler = Isolate.current.addOnExitCallback(() async { await listeningStatsService.flush(); await Hive.close(); }); } catch (_) {} runApp(const Musify()); }

#### Ausencia total de hover effects (onHover/MouseRegion) en widgets interactivos

- **Área:** INPUT Y EVENTOS - portabilidad Android a Windows
- **Archivo:** `lib/widgets/mini_player.dart` línea 179
- **Fragmento:** `AnimatedBuilder > Transform.scale > GestureDetector`
- **Descripción:** Ningun widget en la carpeta widgets/ implementa onHover ni MouseRegion. En Windows el hover es el mecanismo principal para descubrir elementos interactivos, pero botones de play/pause, skip, shuffle, barras de cancion/artista/playlist carecen de feedback visual al hover. Cero apariciones de onHover en los 35+ archivos revisados.
- **Reproducción:** Abrir la app en Windows. Pasar el mouse sobre cualquier boton o elemento de lista. No hay cambio de cursor, color ni highlight. El usuario no sabe que el elemento es interactivo hasta que hace clic.

#### Cero keyboard shortcuts: ni Shortcuts, Actions, CallbackShortcuts ni onKeyEvent

- **Área:** INPUT Y EVENTOS - portabilidad Android a Windows
- **Archivo:** `lib/widgets/now_playing/now_playing_controls.dart` línea 61
- **Fragmento:** `class NowPlayingControls extends StatelessWidget`
- **Descripción:** Zero widgets de Shortcuts, Actions, CallbackShortcuts, HardwareKeyboard, Focus.onKeyEvent ni KeyboardListener en todo lib/. En Windows el teclado fisico es metodo primario de navegacion. Un reproductor debe responder a Space (play/pause), Ctrl+Left/Right (skip), Escape (cerrar dialogo). No existe ningun mecanismo de keyboard bindings.
- **Reproducción:** Abrir la app en Windows. Presionar Space esperando play/pause: no ocurre nada. Presionar Ctrl+Left esperando skip: no ocurre nada. Cerrar dialogo con Escape: no funciona.

#### Teclas multimedia no capturadas en C++ runner

- **Área:** INPUT Y EVENTOS - portabilidad Android a Windows
- **Archivo:** `windows/runner/win32_window.cpp` línea 181
- **Fragmento:** `switch (message) { case WM_DESTROY: case WM_DPICHANGED: case WM_SIZE: case WM_ACTIVATE: case WM_DWMCOLORIZATIONCOLORCHANGED: }`
- **Descripción:** win32_window.cpp maneja WM_DESTROY, WM_DPICHANGED, WM_SIZE y WM_ACTIVATE pero NO maneja WM_KEYDOWN/WM_APPCOMMAND para teclas multimedia (VK_MEDIA_PLAY_PAUSE, VK_MEDIA_NEXT_TRACK, VK_MEDIA_PREV_TRACK). Tampoco hay RegisterHotKey. Las teclas multimedia se pierden en DefWindowProc.
- **Reproducción:** Conectar teclado multimedia en Windows y presionar Play/Pause, Next Track, Prev Track. El reproductor no responde.

#### receive_sharing_intent no declara soporte Windows: rompe el build

- **Área:** Portabilidad Android a Windows - BUILD, DEPENDENCIAS Y CONFIGURACION
- **Archivo:** `C:\Extension\Musify\packages\receive_sharing_intent\pubspec.yaml` línea 27-33
- **Fragmento:** `flutter:
  plugin:
    platforms:
      android:
        package: com.kasem.receive_sharing_intent
        pluginClass: ReceiveSharingIntentPlugin
      ios:
        pluginClass: ReceiveSharingIntentP...`
- **Descripción:** El plugin custom receive_sharing_intent solo declara soporte para Android e iOS. No tiene bloque 'windows:' en su declaracion plugin. Sin embargo, es importado y usado incondicionalmente en lib/main.dart:54 (import) y lib/main.dart:138 (ReceiveSharingIntent.getTextStream().listen(...)). Flutter al compilar para Windows detectara que el plugin no soporta la plataforma y fallara con un error del tipo 'Plugin receive_sharing_intent doesn't support windows'. Esto IMPIDE completar el build de Windows.
- **Reproducción:** Ejecutar 'flutter build windows --release' en el proyecto. El build fallara porque receive_sharing_intent no tiene implementacion para Windows.
- **Detectable por test:** Sí (test_integracion)
- **Corrección propuesta:** Agregar un stub/shim de Windows para receive_sharing_intent (crear packages/receive_sharing_intent/windows/ con CMakeLists.txt, plugin class stub, y declarar en pubspec.yaml), O hacer el import condicional solo para Android/iOS usando dart:io Platform.isAndroid / Platform.isIOS, O migrar a receive_sharing_intent_plus que tiene soporte Windows.

### Alto (15)

#### SystemNavigator.pop() es no-op en Windows: boton atras no cierra la app

- **Área:** NAVEGACION Y FLUJOS
- **Archivo:** `C:\Extension\Musify\lib\screens\bottom_navigation_page.dart` línea 65
- **Fragmento:** `SystemNavigator.pop();`
- **Descripción:** SystemNavigator.pop() en Flutter Windows es una llamada a platform channel que el embedding de Windows ignora silenciosamente. En Android cierra la app, en Windows no hace nada. El PopScope (linea 56-67) maneja correctamente la navegacion entre tabs (si no es Home, va a Home), pero al llegar a Home tab con currentIndex==0, canPop=true, y al no poder hacer pop llama SystemNavigator.pop(). El usuario que presione Backspace/Escape en Home no obtendra respuesta alguna.
- **Reproducción:** 1. Compilar y ejecutar en Windows. 2. Estando en Home tab (indice 0). 3. Presionar tecla Backspace. 4. No ocurre nada: la app no se cierra, no hay feedback. 5. El unico modo de cerrar la app es el boton X de la ventana o Alt+F4.
- **Detectable por test:** Sí (test_integracion)

#### PlaylistPage acepta playlistId nullable sin validacion de borde

- **Área:** NAVEGACION Y FLUJOS
- **Archivo:** `C:\Extension\Musify\lib\screens\playlist_page.dart` línea 59
- **Fragmento:** `this.playlistId,`
- **Descripción:** PlaylistPage.playlistId es String? nullable. Aunque las rutas actuales siempre pasan playlistId desde pathParameters, no hay guard en la pagina misma. Si playlistId y playlistData son ambos null, _resolvedPlaylistId (linea 84-87) retorna null, e _initializePlaylist (linea 137) llama getPlaylistInfoForWidget(null) que falla silenciosamente. La pantalla queda en estado de carga (Spinner, linea 210) hasta que la excepcion es capturada (linea 178) mostrando EmptyPlaylistState generico. Una navegacion programatica erronea, o un path parameter vacio, produce una UX degradada sin mensaje claro.
- **Reproducción:** 1. Programaticamente navegar sin playlistId: context.push('/home/playlist/null'). 2. PlaylistPage entra en estado de carga con CircularProgressIndicator. 3. Eventualmente muestra EmptyPlaylistState con mensaje generico de error, sin indicar que falta el parametro.
- **Detectable por test:** Sí (test_unitario)

#### AudioSession.instance.configure puede fallar silenciosamente en Windows

- **Área:** Portabilidad Android a Windows (APIs de Plataforma)
- **Archivo:** `lib/services/audio_service.dart` línea 404-405
- **Fragmento:** `final session = await AudioSession.instance;
await session.configure(const AudioSessionConfiguration.music());`
- **Descripción:** AudioSession (audio_session: ^0.2.4) en Windows podria no configurar la sesion de audio correctamente. El metodo configure puede lanzar PlatformException en Windows si el backend WASAPI no se puede inicializar o si el plugin no esta implementado para Windows. Aunque esta dentro de try-catch, significa que las propiedades de audio session (ducking, mixing con otras apps) nunca se aplican.
- **Reproducción:** 1. Ejecutar en Windows. 2. AudioSession.instance funciona pero session.configure falla si el plugin Windows no implementa la configuracion. 3. La exception se loggea pero la sesion de audio queda sin configurar. 4. Posibles sintomas: sin audio ducking, conflictos con otras apps de audio.
- **Detectable por test:** Sí (test_widget)
- **Corrección propuesta:** Envolver session.configure en su propio try-catch con log especifico. Verificar que audio_session 0.2.4 tenga implementacion Windows completa. Si no, marcar como no-soportado y continuar sin configuracion de sesion.

#### Hardcodeo de separador '/' en construccion de rutas en io_service.dart

- **Área:** SISTEMA DE ARCHIVOS Y RUTAS
- **Archivo:** `C:/Extension/Musify/lib/services/io_service.dart` línea 36-41
- **Fragmento:** `static String getAudioPath(String songId) { return '$applicationDirPath/$tracksDir/$songId$audioExtension'; } static String getArtworkPath(String songId) { return '$applicationDirPath/$artworksDir/$songId$artworkExtension'; }`
- **Descripción:** Las rutas se construyen con interpolacion de strings usando '/' hardcodeado. En Dart, la clase File/Directory normaliza internamente los separadores, por lo que en muchos casos funciona. Sin embargo, las rutas resultantes se almacenan en offlineSong['audioPath'] y offlineSong['artworkPath'] (common_services.dart:741) y se muestran en logs o se comparan con otras rutas, pudiendo crear inconsistencias. No se usa Platform.pathSeparator ni el paquete 'path' (p.join).
- **Reproducción:** En Windows, getAudioPath('abc123') retorna algo como 'C:\Users\User\AppData\Roaming\Musify/tracks/abc123.m4a' con separadores mixtos. Aunque File() lo maneja, otras operaciones como busqueda por string o logs mostraran rutas inconsistentes.
- **Detectable por test:** Sí (test_unitario)
- **Corrección propuesta:** Usar el paquete 'path' (import 'package:path/path.dart' as p) y construir rutas con p.join(applicationDirPath, tracksDir, '$songId$audioExtension'). O usar directamente Platform.pathSeparator. En Dart moderno, File('...') en Windows acepta /, pero para consistencia y legibilidad se recomienda p.join().

#### Actualizaciones solo abren URL en navegador, no descargan instalador Windows

- **Área:** SISTEMA DE ARCHIVOS Y RUTAS
- **Archivo:** `C:/Extension/Musify/lib/services/update_manager.dart` línea 157-159
- **Fragmento:** `onPressed: () { getDownloadUrl(map).then( (url) => {launchURL(Uri.parse(url)), Navigator.pop(context)} ); }`
- **Descripción:** Cuando se detecta una actualizacion, el boton 'Download' abre la URL del release de GitHub en el navegador usando launchURL. En Android, esto lleva al APK. En Windows, abre la pagina del release pero no hay logica para detectar automaticamente el asset correcto para Windows ni para descargarlo directamente al sistema de archivos.
- **Reproducción:** En Windows, al hacer clic en 'Download', se abre el navegador en la pagina del release de GitHub. El usuario debe navegar manualmente hasta la seccion de Assets, identificar el .exe o .msix correcto, descargarlo, y ejecutarlo.
- **Detectable por test:** No (manual)
- **Corrección propuesta:** Implementar un mecanismo de actualizacion para Windows que descargue el asset .exe/.msix directamente a una carpeta temporal y lo ejecute. Usar Platform.isWindows para seleccionar el asset correcto de la API de GitHub. Alternativamente, usar un paquete como window_manager para manejar actualizaciones.

#### AudioServiceConfig con parametros Android-only que no aplican en Windows

- **Área:** CICLO DE VIDA Y ESTADO
- **Archivo:** `lib/main.dart` línea 306
- **Fragmento:** `audioHandler = await AudioService.init(
  builder: MusifyAudioHandler.new,
  config: const AudioServiceConfig(
    androidNotificationChannelId: 'com.gokadzev.musify',
    androidNotificationChannelName: 'Musify',
    androidNotificationIcon: 'drawable/ic_launcher_foreground',
    androidShowNotificationBadge: true,
    androidStopForegroundOnPause: false,
  ),
);`
- **Descripción:** La configuracion de AudioService contiene exclusivamente parametros Android (notification channel, icon, badge). Aunque audio_service los ignora silenciosamente en Windows, no hay configuracion equivalente para Windows ni separacion de plataformas. En Windows no habra notificaciones de reproduccion ni integracion con el area de notificaciones del sistema.
- **Reproducción:** 1. Ejecutar Musify en Windows. 2. Reproducir una cancion. 3. Minimizar la ventana. 4. No aparece ningun control de reproduccion en el area de notificaciones de Windows ni en la bandeja del sistema.
- **Detectable por test:** No (test_automatizado_e2e)
- **Corrección propuesta:** Separar la configuracion por plataforma usando Platform.isAndroid/Platform.isWindows. Para Windows, usar AudioServiceConfig sin parametros Android y, si es necesario, integrar con taskbar ThumbnailToolbarButtons de Windows o con la Windows Media Transport Control via plugin complementario.

#### AppLifecycleState.detached no se emite confiablemente en Windows antes de terminacion

- **Área:** CICLO DE VIDA Y ESTADO
- **Archivo:** `lib/main.dart` línea 208
- **Fragmento:** `if (state == AppLifecycleState.inactive ||
    state == AppLifecycleState.paused ||
    state == AppLifecycleState.hidden ||
    state == AppLifecycleState.detached) {
  listeningStatsService.recordListeningSessionProgress(
    wasPlaying: audioHandler.audioPlayer.playing,
  );
  unawaited(listeningStatsService.flush());
}`
- **Descripción:** El manejador de didChangeAppLifecycleState depende de recibir AppLifecycleState.detached antes de que el proceso termine. En Flutter Windows, la emision de detached no esta garantizada cuando se cierra la ventana directamente (via Alt+F4 o boton X). Esto significa que listeningStatsService.flush() nunca se ejecuta antes de la salida, perdiendo los segundos finales de escucha y potencialmente la sesion completa si la app se cerro mientras reproducia.
- **Reproducción:** 1. Abrir Musify en Windows. 2. Reproducir musica por varios minutos. 3. Cerrar ventana con Alt+F4. 4. Reabrir. 5. Verificar estadisticas de escucha: los ultimos segundos/minutos no se registraron.
- **Detectable por test:** No (test_automatizado_e2e)
- **Corrección propuesta:** Mover flush() obligatorio al inicio de main() o agregar el hook de cierre descrito en el hallazgo critico. Ademas, considerar escribir en Hive en intervalos periodicos (cada 30s) en lugar de solo en eventos de ciclo de vida, para minimizar perdida de datos.

#### Queue, historial y shuffle state solo en memoria: se pierden al reiniciar en Windows

- **Área:** CICLO DE VIDA Y ESTADO
- **Archivo:** `lib/services/audio_service.dart` línea 96
- **Fragmento:** `final List<Map> _queueList = [];
final List<Map> _originalQueueList = [];
final List<Map> _historyList = [];
int _currentQueueIndex = 0;`
- **Descripción:** Toda la cola de reproduccion, historial, estado de shuffle e indice actual se mantienen exclusivamente en memoria (en instancia de MusifyAudioHandler). A diferencia de Android donde el servicio puede persistir via MediaSession o el propio ciclo de vida de Activity, en Windows al cerrar y reabrir la app se pierde completamente el estado de reproduccion. No hay serializacion ni restauracion de la cola entre sesiones.
- **Reproducción:** 1. Reproducir varias canciones en cola en Musify Windows. 2. Cerrar la app. 3. Reabrir. 4. La cola esta vacia y no hay forma de retomar donde se quedo.
- **Detectable por test:** Sí (test_unitario)
- **Corrección propuesta:** Persistir _queueList, _currentQueueIndex, shuffle mode, y posicion actual en Hive dentro de onTaskRemoved() o en un shutdown hook. Al iniciar, restaurar desde Hive. Crear metodos savePlaybackState() y restorePlaybackState() en MusifyAudioHandler.

#### onTaskRemoved() solo tiene efecto en Android: no hay limpieza en Windows close

- **Área:** CICLO DE VIDA Y ESTADO
- **Archivo:** `lib/services/audio_service.dart` línea 1738
- **Fragmento:** `@override
Future<void> onTaskRemoved() async {
  try {
    await stop();
    final session = await AudioSession.instance;
    await session.setActive(false);
  } catch (e, stackTrace) {
    logger.log('Error in onTaskRemoved'
- `C:\Extension\Musify\lib\utilities\async_loader.dart`
- `C:\Extension\Musify\lib\utilities\mediaitem.dart`
- `C:\Extension\Musify\lib\widgets\mini_player.dart`
- `C:\Extension\Musify\lib\widgets\queue_list_view.dart`
- `C:\Extension\Musify\lib\screens\now_playing_page.dart`
- `C:\Extension\Musify\lib\screens\home_page.dart`
- `C:\Extension\Musify\lib\constants\version.dart`
- `C:\Extension\Musify\pubspec.yaml`

##### Hive.close() en widget dispose() no se ejecuta al cerrar ventana Windows
- **Severidad:** critico
- **Archivo:** `lib/main.dart`:221
- **Código:**
```dart
Hive.close(); // Dentro de _MusifyState.dispose()
```
- **Descripción:** El cierre de Hive solo ocurre en el metodo dispose() del widget raiz. En Windows, al cerrar la ventana (click en X), el proceso termina inmediatamente y dispose() de los widgets NO se invoca de forma confiable. Esto puede corromper las cajas Hive (settings, user, userNoBackup, cache) y perder datos de escucha en progreso.
- **Reproducción:** 1. Abrir Musify en Windows. 2. Reproducir musica. 3. Cerrar la ventana con el boton X. 4. Reabrir Musify. 5. Las cajas Hive pueden aparecer corruptas o la app crashea al intentar leer datos.
- **Test:** Sí (test_unitario)
- **Corrección propuesta:** Agregar un manejador de cierre en Windows usando dart:io ProcessSignal.sigterm o un callback en SystemChannels.lifecycle. Envolver Hive.close() dentro de un shutdown hook que se ejecute antes de que el proceso termine.

##### AudioServiceConfig con parametros Android-only que no aplican en Windows
- **Severidad:** alto
- **Archivo:** `lib/main.dart`:306
- **Código:**
```dart
audioHandler = await AudioService.init(
  builder: MusifyAudioHandler.new,
  config: const AudioServiceConfig(
    androidNotificationChannelId: 'com.gokadzev.musify',
    androidNotificationChannelName: 'Musify',
    androidNotificationIcon: 'drawable/ic_launcher_foreground',
    androidShowNotificationBadge: true,
    androidStopForegroundOnPause: false,
  ),
);
```
- **Descripción:** La configuracion de AudioService contiene exclusivamente parametros Android. Aunque audio_service los ignora silenciosamente en Windows, no hay configuracion equivalente para Windows ni separacion de plataformas.
- **Reproducción:** 1. Ejecutar Musify en Windows. 2. Reproducir una cancion. 3. Minimizar la ventana. 4. No aparece ningun control de reproduccion en el area de notificaciones de Windows.
- **Test:** No (test_automatizado_e2e)
- **Corrección propuesta:** Separar la configuracion por plataforma usando Platform.isAndroid/Platform.isWindows.

##### AppLifecycleState.detached no se emite confiablemente en Windows antes de terminacion
- **Severidad:** alto
- **Archivo:** `lib/main.dart`:208
- **Código:** `listeningStatsService.recordListeningSessionProgress` + `listeningStatsService.flush()`
- **Descripción:** El manejador de didChangeAppLifecycleState depende de recibir AppLifecycleState.detached antes de que el proceso termine. En Flutter Windows, la emision de detached no esta garantizada al cerrar la ventana directamente.
- **Reproducción:** 1. Abrir Musify en Windows. 2. Reproducir musica por varios minutos. 3. Cerrar ventana con Alt+F4. 4. Reabrir. 5. Verificar estadisticas de escucha: los ultimos segundos/minutos no se registraron.
- **Test:** No (test_automatizado_e2e)
- **Corrección propuesta:** Mover flush() obligatorio al inicio de main() o agregar un shutdown hook.

##### Queue, historial y shuffle state solo en memoria: se pierden al reiniciar en Windows
- **Severidad:** alto
- **Archivo:** `lib/services/audio_service.dart`:96
- **Código:**
```dart
final List<Map> _queueList = [];
final List<Map> _originalQueueList = [];
final List<Map> _historyList = [];
int _currentQueueIndex = 0;
```
- **Descripción:** Toda la cola de reproduccion, historial, shuffle e indice actual se mantienen exclusivamente en memoria. En Windows al cerrar y reabrir la app se pierde completamente el estado.
- **Reproducción:** 1. Reproducir varias canciones en cola en Windows. 2. Cerrar la app. 3. Reabrir. 4. La cola esta vacia.
- **Test:** Sí (test_unitario)
- **Corrección propuesta:** Persistir queueList, currentQueueIndex, shuffle mode y posicion en Hive al cerrar; restaurar al iniciar.

##### onTaskRemoved() solo tiene efecto en Android: no hay limpieza en Windows close
- **Severidad:** alto
- **Archivo:** `lib/services/audio_service.dart`:1738
- **Código:** `onTaskRemoved()` con `stop()` y `session.setActive(false)`
- **Descripción:** onTaskRemoved() solo se dispara en Android. En Windows al cerrar la app nunca se ejecuta. stop() no se llama y recursos quedan colgados.
- **Reproducción:** 1. Musify en Windows. 2. Reproducir cancion. 3. Cerrar ventana. 4. stop() no se ejecuta.
- **Test:** No (test_automatizado_e2e)
- **Corrección propuesta:** Agregar listener de cierre de ventana que ejecute la misma logica de onTaskRemoved().

##### ReceiveSharingIntent puede no funcionar en Windows por lifecycle differences
- **Severidad:** medio
- **Archivo:** `lib/main.dart`:138
- **Descripción:** receive_sharing_intent fue disenado para Android/iOS. En Windows no existe el concepto de intent. La funcionalidad no funciona y el stream subscription queda activa.
- **Reproducción:** 1. Compartir link de YouTube a Musify en Windows. 2. No ocurre nada.
- **Test:** No (manual)
- **Corrección propuesta:** Encerrar con Platform.isAndroid. En Windows manejar argumentos de linea de comandos.

##### AppLifecycleState.hidden checkeado pero no existe semanticamente igual en Windows
- **Severidad:** medio
- **Archivo:** `lib/main.dart`:207
- **Código:** `state == AppLifecycleState.hidden`
- **Descripción:** hidden se emite con semantica diferente en Windows, causando doble flush con paused.
- **Reproducción:** Minimizar ventana. Se emiten paused e hidden. listeningStatsService.flush() se invoca dos veces.
- **Test:** No (test_automatizado_e2e)

##### AudioSession.configure() no tiene comportamiento equivalente en Windows
- **Severidad:** medio
- **Archivo:** `lib/services/audio_service.dart`:404
- **Código:** `session.configure(const AudioSessionConfiguration.music())`
- **Descripción:** AudioSession.configure() es API disenada para iOS/Android. En Windows no tiene efecto real.
- **Reproducción:** La llamada no produce errores ni efectos observables.
- **Test:** No (test_automatizado_e2e)
- **Corrección propuesta:** Documentar como no-op. Usar win32 o flutter_volume_controller para control especifico de Windows.

##### DataManager._openBox() reabre Hive boxes sin control de ciclo de vida
- **Severidad:** medio
- **Archivo:** `lib/services/data_manager.dart`:208
- **Código:** `_openBox()` que reabre si cerrado
- **Descripción:** Si Hive.close() corre mientras otros componentes usan boxes, _openBox reabre causando inconsistencias.
- **Reproducción:** Hive.close() en dispose() mientras stream callback lee de box. _openBox reabre caja parcialmente cerrada.
- **Test:** Sí (test_unitario)
- **Corrección propuesta:** Usar contador de referencias para Hive.close().

##### No hay manejo de Isolate para background audio en Windows vs Android
- **Severidad:** bajo
- **Archivo:** `lib/services/audio_service.dart`
- **Descripción:** En Android audio_service crea isolate separado. En Windows no es necesario porque el proceso no se mata al minimizar.
- **Reproducción:** No aplica: diferencia arquitectonica documentada.
- **Test:** No (manual)
- **Corrección propuesta:** Documentar que en Windows no se necesita background Isolate.

### INPUT Y EVENTOS - portabilidad Android a Windows

**Archivos revisados (35):**

- `lib/widgets/custom_bar.dart`
- `lib/widgets/custom_search_bar.dart`
- `lib/widgets/bottom_sheet_bar.dart`
- `lib/widgets/position_slider.dart`
- `lib/widgets/playback_icon_button.dart`
- `lib/widgets/overflow_menu_button.dart`
- `lib/widgets/popup_menu_item.dart`
- `lib/widgets/song_bar.dart`
- `lib/widgets/artist_bar.dart`
- `lib/widgets/playlist_bar.dart`
- `lib/widgets/mini_player.dart`
- `lib/widgets/mini_player_bottom_space.dart`
- `lib/widgets/now_playing/now_playing_controls.dart`
- `lib/widgets/now_playing/bottom_actions_row.dart`
- `lib/widgets/now_playing/marquee_text_widget.dart`
- `lib/widgets/playlist_page/playlist_action_buttons.dart`
- `lib/widgets/playlist_page/shuffle_play_button.dart`
- `lib/widgets/queue_list_view.dart`
- `lib/widgets/radio_station_card.dart`
- `lib/widgets/sort_chips.dart`
- `lib/widgets/confirmation_dialog.dart`
- `lib/widgets/edit_playlist_dialog.dart`
- `lib/widgets/rename_song_dialog.dart`
- `lib/widgets/dialog_item.dart`
- `lib/widgets/video/video_test_widget.dart`
- `lib/widgets/video/youtube_video_player.dart`
- `lib/widgets/playlist_cube.dart`
- `lib/widgets/spinner.dart`
- `lib/widgets/marquee.dart`
- `lib/widgets/section_header.dart`
- `lib/widgets/section_title.dart`
- `lib/utilities/app_icon.dart`
- `windows/runner/win32_window.cpp`
- `windows/runner/win32_window.h`
- `windows/runner/flutter_window.cpp`

##### Ausencia total de hover effects (onHover/MouseRegion) en widgets interactivos
- **Severidad:** critico
- **Archivo:** `lib/widgets/mini_player.dart`:179
- **Descripción:** Ningun widget implementa onHover ni MouseRegion. Los botones carecen de feedback visual al hover.
- **Reproducción:** Pasar el mouse sobre botones. No hay cambio de cursor, color ni highlight.

##### Cero keyboard shortcuts: ni Shortcuts, Actions, CallbackShortcuts ni onKeyEvent
- **Severidad:** critico
- **Archivo:** `lib/widgets/now_playing/now_playing_controls.dart`:61
- **Descripción:** Zero widgets de Shortcuts, Actions, CallbackShortcuts, HardwareKeyboard, Focus.onKeyEvent ni KeyboardListener en todo lib/.
- **Reproducción:** Presionar Space: no play/pause. Ctrl+Left: no skip. Escape: no cierra dialogo.

##### Teclas multimedia no capturadas en C++ runner
- **Severidad:** critico
- **Archivo:** `windows/runner/win32_window.cpp`:181
- **Descripción:** No maneja WM_KEYDOWN/WM_APPCOMMAND para VK_MEDIA_PLAY_PAUSE, VK_MEDIA_NEXT_TRACK, VK_MEDIA_PREV_TRACK.
- **Reproducción:** Teclas multimedia no responden en el reproductor.

##### Ausencia de FocusNode/FocusTraversalGroup para navegacion por Tab
- **Severidad:** alto
- **Archivo:** `lib/widgets/custom_search_bar.dart`:38
- **Descripción:** Solo 2 de 35+ archivos usan FocusNode. No hay FocusTraversalGroup ni orden de foco.
- **Reproducción:** Tab solo navega search bars, no botones ni listas.

##### Play/pause y skip en mini_player sin tooltip
- **Severidad:** alto
- **Archivo:** `lib/widgets/mini_player.dart`:399
- **Descripción:** IconButton skip-to-next y CircularPlayButton sin tooltip.
- **Reproducción:** Pasar mouse sobre play/pause y next en mini_player. No aparece tooltip.

##### RawMaterialButton de play/pause sin tooltip ni feedback hover
- **Severidad:** alto
- **Archivo:** `lib/widgets/playback_icon_button.dart`:103
- **Descripción:** RawMaterialButton con splashColor: Colors.transparent, sin tooltip ni hover.
- **Reproducción:** Pasar mouse sobre play/pause en Now Playing. Sin highlight ni tooltip.

##### InkWell con onLongPress sin onSecondaryTap para click derecho
- **Severidad:** alto
- **Archivo:** `lib/widgets/custom_bar.dart`:59
- **Descripción:** InkWell no maneja onSecondaryTap (click derecho). Click derecho en items no tiene efecto.
- **Reproducción:** Click derecho en item de lista. No ocurre nada.

##### Boton video en mini_player usa GestureDetector sin tooltip ni click derecho
- **Severidad:** medio
- **Archivo:** `lib/widgets/mini_player.dart`:350
- **Descripción:** GestureDetector sin tooltip, hover state, ripple ni foco.
- **Reproducción:** Pasar mouse sobre icono de video. Sin tooltip.

##### Drag and drop en queue no optimizado para mouse desktop
- **Severidad:** medio
- **Archivo:** `lib/widgets/queue_list_view.dart`:296
- **Descripción:** ReorderableListView requiere click preciso y hold. UX torpe en desktop.
- **Reproducción:** Arrastrar item en queue. Experiencia no natural en desktop.

##### Slider posicion no responde a scroll wheel
- **Severidad:** medio
- **Archivo:** `lib/widgets/position_slider.dart`:64
- **Descripción:** Slider solo responde a click y drag, no a scroll wheel.
- **Reproducción:** Girar rueda del mouse sobre slider de progreso. No cambia posicion.

##### OverflowMenuButton sin tooltip propio
- **Severidad:** bajo
- **Archivo:** `lib/widgets/overflow_menu_button.dart`:48
- **Descripción:** PopupMenuButton icono 'more' sin tooltip.
- **Reproducción:** Pasar mouse sobre tres puntos. No aparece tooltip.

##### Ventana sin tamano minimo (WM_GETMINMAXINFO)
- **Severidad:** bajo
- **Archivo:** `windows/runner/win32_window.cpp`:137
- **Descripción:** No hay WM_GETMINMAXINFO handler. UI se rompe al redimensionar a <200px.
- **Reproducción:** Redimensionar a <200px ancho. UI colapsa.

### LAYOUT Y DIMENSIONES - Portabilidad Android a Windows

**Archivos revisados (0):**


### Portabilidad Android a Windows - BUILD, DEPENDENCIAS Y CONFIGURACION

**Archivos revisados (34):**

- `C:\Extension\Musify\pubspec.yaml`
- `C:\Extension\Musify\pubspec.lock`
- `C:\Extension\Musify\windows\CMakeLists.txt`
- `C:\Extension\Musify\windows\flutter\CMakeLists.txt`
- `C:\Extension\Musify\windows\flutter\generated_plugins.cmake`
- `C:\Extension\Musify\windows\flutter\generated_plugin_registrant.cc`
- `C:\Extension\Musify\windows\flutter\generated_plugin_registrant.h`
- `C:\Extension\Musify\windows\runner\CMakeLists.txt`
- `C:\Extension\Musify\windows\runner\main.cpp`
- `C:\Extension\Musify\windows\runner\runner.exe.manifest`
- `C:\Extension\Musify\windows\runner\Runner.rc`
- `C:\Extension\Musify\windows\runner\resource.h`
- `C:\Extension\Musify\windows\runner\utils.h`
- `C:\Extension\Musify\analysis_options.yaml`
- `C:\Extension\Musify\crowdin.yml`
- `C:\Extension\Musify\l10n.yaml`
- `C:\Extension\Musify\update.sh`
- `C:\Extension\Musify\.metadata`
- `C:\Extension\Musify\.gitignore`
- `C:\Extension\Musify\quality_gate.ps1`
- `C:\Extension\Musify\android\app\build.gradle.kts`
- `C:\Extension\Musify\android\build.gradle.kts`
- `C:\Extension\Musify\android\settings.gradle.kts`
- `C:\Extension\Musify\android\gradle.properties`
- `C:\Extension\Musify\packages\receive_sharing_intent\pubspec.yaml`
- `C:\Extension\Musify\packages\youtube_explode_dart\pubspec.yaml`
- `C:\Extension\Musify\packages\youtube_music_explode_dart\pubspec.yaml`
- `C:\Extension\Musify\.github\workflows\windows-release.yml`
- `C:\Extension\Musify\.github\workflows\release.yml`
- `C:\Extension\Musify\.github\workflows\pre_release.yml`
- `C:\Extension\Musify\lib\constants\version.dart`
- `C:\Extension\Musify\lib\main.dart`
- `C:\Extension\Musify\lib\services\audio_service.dart`
- `C:\Extension\Musify\lib\utilities\sharing_intent.dart`

##### receive_sharing_intent no declara soporte Windows: rompe el build
- **Severidad:** critico
- **Archivo:** `C:\Extension\Musify\packages\receive_sharing_intent\pubspec.yaml`:27-33
- **Código:** Solo declaracion Android e iOS, falta windows:
- **Descripción:** Flutter detecta que el plugin no soporta Windows y falla el build.
- **Reproducción:** flutter build windows --release falla.
- **Test:** Sí (test_integracion)
- **Corrección propuesta:** Agregar stub Windows o hacer import condicional.

##### version.dart desincronizado respecto a pubspec.yaml
- **Severidad:** alto
- **Archivo:** `C:\Extension\Musify\lib\constants\version.dart`:1
- **Código:** `const appVersion = '10.1.1';` vs pubspec.yaml `version: 10.1.2+177`
- **Descripción:** version.dart muestra version incorrecta.
- **Reproducción:** Comparar pubspec.yaml:8 con version.dart:1.
- **Test:** Sí (test_unitario)
- **Corrección propuesta:** Ejecutar update.sh o generar version.dart automaticamente.

##### CI Windows no ejecuta flutter analyze antes del build
- **Severidad:** alto
- **Archivo:** `C:\Extension\Musify\.github\workflows\windows-release.yml`:29-31
- **Descripción:** Solo pub get + build, sin flutter analyze. Errores pasan desapercibidos.
- **Reproducción:** Comparar con release.yml que SI tiene analyze.
- **Test:** No (manual)
- **Corrección propuesta:** Agregar '- run: flutter analyze' entre pub get y build.

##### update.sh es Bash-only, no funciona en Windows nativo
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\update.sh`:1-4
- **Descripción:** Script Bash con grep/awk que no funciona en cmd.exe/PowerShell.
- **Reproducción:** Ejecutar en cmd.exe falla.
- **Test:** No (manual)
- **Corrección propuesta:** Crear equivalente Dart cross-platform.

##### windows-release.yml usa flutter-version hardcodeada
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\.github\workflows\windows-release.yml`:19
- **Descripción:** '3.44.x' hardcodeado vs Android que extrae de pubspec.yaml.
- **Reproducción:** Comparar con release.yml:48-53 que usa deteccion dinamica.
- **Test:** No (manual)
- **Corrección propuesta:** Extraer version de pubspec.yaml como Android.

##### Runner.rc: FileDescription y ProductName en minusculas
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\windows\runner\Runner.rc`:93,98
- **Código:** `VALUE "FileDescription", "musify"` y `VALUE "ProductName", "musify"`
- **Descripción:** Metadatos del ejecutable en minusculas. Se ve mal en Propiedades.
- **Reproducción:** Ver Propiedades -> Detalles del .exe compilado.
- **Test:** No (manual)
- **Corrección propuesta:** Cambiar a 'Musify'.

##### runner.exe.manifest solo declara Windows 10/11, falta Windows 8.1
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\windows\runner\runner.exe.manifest`:11
- **Descripción:** Solo GUID de Win 10/11, falta Win 8.1.
- **Reproducción:** Inspeccionar runner.exe.manifest.
- **Test:** No (manual)
- **Corrección propuesta:** Agregar GUID de Win 8.1.

##### flutter_lints desactivado, analysis_options.yaml manual
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\pubspec.yaml`:52
- **Código:** `# flutter_lints: ^2.0.0`
- **Descripción:** flutter_lints comentado. Reglas manuales dificiles de mantener.
- **Reproducción:** Ver pubspec.yaml:52.
- **Test:** No (manual)
- **Corrección propuesta:** Descomentar flutter_lints y simplificar analysis_options.yaml.

##### quality_gate.ps1 tiene paths absolutos hardcodeados
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\quality_gate.ps1`:6,76
- **Código:** `$root = "C:\Extension\Musify"`
- **Descripción:** Paths absolutos. Fall si se clona en otra ubicacion.
- **Reproducción:** Clonar en otra carpeta, ejecutar. Falla.
- **Test:** No (manual)
- **Corrección propuesta:** Usar $PSScriptRoot.

##### .gitignore excluye *.exe y libmpv-2.dll
- **Severidad:** bajo
- **Archivo:** `C:\Extension\Musify\.gitignore`:54-55
- **Descripción:** Excluye redundante (build/ ya cubre). Inofensivo.
- **Reproducción:** Verificar lineas.
- **Test:** No (manual)
- **Corrección propuesta:** Opcional: eliminar lineas redundantes.

##### Sin workflow pre-release para Windows
- **Severidad:** bajo
- **Archivo:** `C:\Extension\Musify\.github\workflows\windows-release.yml`:1-8
- **Descripción:** Solo hay windows-release.yml, no pre-release para Windows.
- **Reproducción:** Comparar cantidad de workflows Android vs Windows.
- **Test:** No (manual)
- **Corrección propuesta:** Crear windows-pre-release.yml.

##### analysis_options.yaml excluye scripts/ con checker.dart
- **Severidad:** bajo
- **Archivo:** `C:\Extension\Musify\analysis_options.yaml`:2-4
- **Descripción:** scripts/ excluido pero checker.dart importa paquetes de la app.
- **Reproducción:** Ver analysis_options.yaml:3.
- **Test:** No (manual)
- **Corrección propuesta:** Eliminar scripts/** de exclusion o mover checker.dart.

##### androidCompactActionIndices hardcodeado en audio_service.dart
- **Severidad:** bajo
- **Archivo:** `C:\Extension\Musify\lib\services\audio_service.dart`:653
- **Código:** `androidCompactActionIndices: const [0, 1, 3],`
- **Descripción:** Solo Android, se ignora en Windows.
- **Reproducción:** Buscar en 3 lugares: lineas 653, 1252, 1716.
- **Test:** No (manual)
- **Corrección propuesta:** Verificar SMTC en Windows.
---

## Hallazgos por Área

### assets_e_iconos/android_a_windows

**Archivos revisados (0):**


### NAVEGACION Y FLUJOS

**Archivos revisados (19):**

- `C:\Extension\Musify\lib\main.dart`
- `C:\Extension\Musify\lib\services\router_service.dart`
- `C:\Extension\Musify\lib\screens\bottom_navigation_page.dart`
- `C:\Extension\Musify\lib\screens\home_page.dart`
- `C:\Extension\Musify\lib\screens\search_page.dart`
- `C:\Extension\Musify\lib\screens\library_page.dart`
- `C:\Extension\Musify\lib\screens\settings_page.dart`
- `C:\Extension\Musify\lib\screens\now_playing_page.dart`
- `C:\Extension\Musify\lib\screens\playlist_page.dart`
- `C:\Extension\Musify\lib\screens\playlist_folder_page.dart`
- `C:\Extension\Musify\lib\screens\artist_page.dart`
- `C:\Extension\Musify\lib\screens\about_page.dart`
- `C:\Extension\Musify\lib\screens\equalizer_page.dart`
- `C:\Extension\Musify\lib\screens\radio_stations_page.dart`
- `C:\Extension\Musify\lib\screens\time_machine_page.dart`
- `C:\Extension\Musify\lib\screens\user_songs_page.dart`
- `C:\Extension\Musify\lib\widgets\mini_player.dart`
- `C:\Extension\Musify\lib\widgets\bottom_sheet_bar.dart`
- `C:\Extension\Musify\lib\utilities\flutter_bottom_sheet.dart`

##### NowPlayingPage fuera del arbol de GoRouter: stack de navegacion hibrido
- **Severidad:** critico
- **Archivo:** `C:\Extension\Musify\lib\widgets\mini_player.dart`:147
- **Código:** `Navigator.of(context).push(_createSlideTransition());`
- **Descripción:** NowPlayingPage se navega via Navigator raw en vez de GoRouter.
- **Reproducción:** 1. Tap mini player desde Home. 2. URL sigue siendo /home. 3. Al reiniciar, NowPlayingPage no se restaura.
- **Test:** Sí (test_widget)

##### SystemNavigator.pop() es no-op en Windows: boton atras no cierra la app
- **Severidad:** alto
- **Archivo:** `C:\Extension\Musify\lib\screens\bottom_navigation_page.dart`:65
- **Código:** `SystemNavigator.pop();`
- **Descripción:** SystemNavigator.pop() no funciona en Windows. Backspace/Escape en Home no cierra la app.
- **Reproducción:** Presionar Backspace en Home. Sin efecto.
- **Test:** Sí (test_integracion)

##### PlaylistPage acepta playlistId nullable sin validacion de borde
- **Severidad:** alto
- **Archivo:** `C:\Extension\Musify\lib\screens\playlist_page.dart`:59
- **Código:** `this.playlistId,`
- **Descripción:** playlistId nullable sin guard. Si ambos son null, pantalla queda en carga.
- **Reproducción:** Navegar a /home/playlist/null. Pantalla se queda en spinner.
- **Test:** Sí (test_unitario)

##### app_links solo escucha stream, nunca getInitialUri
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\lib\main.dart`:322
- **Código:** `appLinks.uriLinkStream.listen(handleIncomingLink, onError: ...)`
- **Descripción:** Nunca se llama getInitialLink(). Deep links de arranque se pierden en Windows.
- **Reproducción:** Iniciar app con musify://playlist/custom/XXXX. No se procesa.
- **Test:** Sí (test_automatizado_e2e)

##### Duplicacion de ruta /home/library sin referencia en la UI
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\lib\services\router_service.dart`:171
- **Código:** `GoRoute(path: 'library', pageBuilder: ...)`
- **Descripción:** /home/library existe pero no hay navegacion desde la UI. Ruta muerta.
- **Reproducción:** No hay boton que navegue a /home/library.
- **Test:** Sí (test_widget)

##### Falta manejo de teclas de navegacion tipicas de Windows
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\lib\screens\bottom_navigation_page.dart`:56
- **Descripción:** No hay handlers para Escape, Alt+Izquierda/Derecha, Ctrl+Tab.
- **Reproducción:** Presionar Escape en Library tab. No ocurre nada.
- **Test:** Sí (test_automatizado_e2e)

##### Equalizer usa AndroidEqualizerParameters sin fallback en Windows
- **Severidad:** medio
- **Archivo:** `C:\Extension\Musify\lib\screens\equalizer_page.dart`:39
- **Código:** `AndroidEqualizerParameters? _params;`
- **Descripción:** Si getEqualizerParameters() retorna null, muestra error generico sin solucion.
- **Reproducción:** Abrir equalizer en Windows con driver no soportado. Muestra 'Equalizer initialization failed'.
- **Test:** Sí (test_widget)

##### routerNeglect:true sin efecto en Windows (codigo muerto)
- **Severidad:** bajo
- **Archivo:** `C:\Extension\Musify\lib\services\router_service.dart`:72
- **Descripción:** Opcion solo Android. Sin efecto en Windows.
- **Test:** No (manual)

##### BouncingScrollPhysics en lugar de ClampingScrollPhysics
- **Severidad:** bajo
- **Archivo:** `C:\Extension\Musify\lib\screens\search_page.dart`:310
- **Código:** `physics: const BouncingScrollPhysics()`
- **Descripción:** BouncingScrollPhysics en vez de ClampingScrollPhysics. Comportamiento iOS no esperado en Windows.
- **Reproducción:** Scroll al final en Search page. Rebota.
- **Test:** Sí (test_widget)

##### Transicion SlideTransition con offset fijo en pantallas anchas
- **Severidad:** bajo
- **Archivo:** `C:\Extension\Musify\lib\services\router_service.dart`:369
- **Código:** `begin: const Offset(0.06, 0)`
- **Descripción:** 6% de ancho en monitores anchos produce slide exagerado.
- **Reproducción:** Navegar en monitor 1920px+. Transicion desde 115px.
- **Test:** Sí (test_widget)

### Portabilidad Android a Windows (APIs de Plataforma)

**Archivos revisados (30):**

- `C:\Extension\Musify\lib\services\audio_service.dart`
- `C:\Extension\Musify\lib\services\io_service.dart`
- `C:\Extension\Musify\lib\services\common_services.dart`
- `C:\Extension\Musify\lib\services\data_manager.dart`
- `C:\Extension\Musify\lib\services\logger_service.dart`
- `C:\Extension\Musify\lib\services\settings_manager.dart`
- `C:\Extension\Musify\lib\services\update_manager.dart`
- `C:\Extension\Musify\lib\services\video_bridge.dart`
- `C:\Extension\Musify\lib\services\proxy_manager.dart`
- `C:\Extension\Musify\lib\services\lyrics_manager.dart`
- `C:\Extension\Musify\lib\services\listening_stats_service.dart`
- `C:\Extension\Musify\lib\services\playlist_download_service.dart`
- `C:\Extension\Musify\lib\services\playlist_sharing.dart`
- `C:\Extension\Musify\lib\services\playlists_manager.dart`
- `C:\Extension\Musify\lib\services\artist_service.dart`
- `C:\Extension\Musify\lib\services\router_service.dart`
- `C:\Extension\Musify\lib\utilities\url_launcher.dart`
- `C:\Extension\Musify\lib\utilities\sharing_intent.dart`
- `C:\Extension\Musify\lib\utilities\flutter_toast.dart`
- `C:\Extension\Musify\lib\utilities\playlist_image_picker.dart`
- `C:\Extension\Musify\lib\utilities\offline_playlist_dialogs.dart`
- `C:\Extension\Musify\lib\utilities\mediaitem.dart`
- `C:\Extension\Musify\lib\constants\clients.dart`
- `C:\Extension\Musify\windows\runner\main.cpp`
- `C:\Extension\Musify\windows\runner\flutter_window.cpp`
- `C:\Extension\Musify\windows\runner\win32_window.cpp`
- `C:\Extension\Musify\windows\runner\utils.cpp`
- `C:\Extension\Musify\packages\receive_sharing_intent\lib\receive_sharing_intent.dart`
- `C:\Extension\Musify\pubspec.yaml`
- `C:\Extension\Musify\lib\main.dart`

##### Process.run('uname', ['-m']) no existe en Windows: crashea getDownloadUrl
- **Severidad:** critico
- **Archivo:** `lib/services/update_manager.dart`:257-261
- **Código:** `Process.run('uname', ['-m'])`
- **Descripción:** uname no existe en Windows. ProcessException rompe flujo de descarga.
- **Reproducción:** Ir a Settings > Updates > Download. Excepcion.
- **Test:** Sí (test_unitario)
- **Corrección:** Reemplazar con deteccion nativa Windows (Platform.environment o wmic).

##### AudioService.init sin fallback si el plugin Windows falla
- **Severidad:** critico
- **Archivo:** `lib/main.dart`:306-315
- **Código:** `AudioService.init(...)` sin try-catch individual
- **Descripción:** Si audio_service no tiene backend Windows, MissingPluginException deja audioHandler sin inicializar.
- **Reproducción:** Compilar y ejecutar sin backend audio_service Windows. LateInitializationError al tocar UI.
- **Test:** Sí (test_integracion)
- **Corrección:** Envolver en try-catch con fallback a MusifyAudioHandler() directo.

##### AudioSession.instance.configure puede fallar silenciosamente en Windows
- **Severidad:** alto
- **Archivo:** `lib/services/audio_service.dart`:404-405
- **Código:** `session.configure(const AudioSessionConfiguration.music())`
- **Descripción:** AudioSession.configure puede fallar en Windows si WASAPI no se inicializa.
- **Reproducción:** Envolver en try-catch propio.
- **Test:** Sí (test_widget)
- **Corrección:** try-catch especifico con log.

##### receive_sharing_intent: package custom sin implementacion Windows, silenciado
- **Severidad:** bajo
- **Archivo:** `packages/receive_sharing_intent/lib/receive_sharing_intent.dart`:22-23
- **Código:** `if (!_isSupported) return [];`
- **Descripción:** Guard condicional funciona. Stream vacio en Windows.
- **Test:** Sí (test_unitario)
- **Corrección:** Opcional - funciona correctamente.

##### Uso de Platform.isAndroid sin branch Platform.isWindows en equalizer
- **Severidad:** bajo
- **Archivo:** `lib/services/audio_service.dart`:43-64
- **Descripción:** Equalizer solo Android. No hay alternativa Windows.
- **Test:** No (manual)
- **Corrección:** Implementar equalizador via media_kit en Windows.

##### Predictive back gesture mostrado en Windows (UI inconsistente)
- **Severidad:** bajo
- **Archivo:** `lib/screens/settings_page.dart`:140
- **Descripción:** Guard con Platform.isAndroid funciona. Opcion no se muestra en Windows.
- **Test:** No (manual)
- **Corrección:** No urgente - limpieza opcional.

##### just_audio_windows declarado correctamente en pubspec.yaml
- **Severidad:** bajo
- **Archivo:** `pubspec.yaml`:36
- **Código:** `just_audio_windows: ^0.2.2`
- **Descripción:** Dependencia correcta para backend WASAPI.
- **Test:** No (manual)
- **Corrección:** N/A - Configuracion correcta.

##### media_kit + media_kit_video + media_kit_libs_windows_video: setup completo
- **Severidad:** bajo
- **Archivo:** `pubspec.yaml`:21-23
- **Código:** `media_kit: ^1.1.10`, `media_kit_video: ^2.0.1`, `media_kit_libs_windows_video: ^1.0.11`
- **Descripción:** Bundle mpv/ffmpeg DLLs nativas correctamente.
- **Test:** No (manual)
- **Corrección:** N/A - Configuracion correcta.

##### url_launcher funciona en Windows nativamente
- **Severidad:** bajo
- **Archivo:** `lib/utilities/url_launcher.dart`:24-29
- **Descripción:** url_launcher ^6.3.2 funciona en Windows con LaunchMode.externalApplication.
- **Test:** No (manual)
- **Corrección:** N/A - Sin problema.

##### path_provider funciona en Windows
- **Severidad:** bajo
- **Archivo:** `lib/main.dart` / `lib/screens/time_machine_page.dart`
- **Descripción:** getApplicationDocumentsDirectory() y getTemporaryDirectory() funcionan correctamente.
- **Test:** No (manual)
- **Corrección:** N/A - Sin problema.

##### share_plus funciona en Windows
- **Severidad:** bajo
- **Archivo:** `lib/screens/time_machine_page.dart`:293-301
- **Descripción:** SharePlus.instance.share abre share sheet nativo Windows.
- **Test:** No (manual)
- **Corrección:** N/A - Sin problema.

##### dart:html no usado en el proyecto (correcto)
- **Severidad:** bajo
- **Descripción:** No hay imports de dart:html. Correcto para Flutter desktop.
- **Test:** No (manual)
- **Corrección:** N/A - Sin problema.
### SISTEMA DE ARCHIVOS Y RUTAS

**Archivos revisados (20):**

- `C:/Extension/Musify/lib/services/io_service.dart`
- `C:/Extension/Musify/lib/services/data_manager.dart`
- `C:/Extension/Musify/lib/database/albums.db.dart`
- `C:/Extension/Musify/lib/database/playlists.db.dart`
- `C:/Extension/Musify/lib/database/radio_stations.db.dart`
- `C:/Extension/Musify/lib/services/settings_manager.dart`
- `C:/Extension/Musify/lib/services/playlist_download_service.dart`
- `C:/Extension/Musify/lib/services/playlists_manager.dart`
- `C:/Extension/Musify/lib/utilities/playlist_image_picker.dart`
- `C:/Extension/Musify/lib/utilities/offline_playlist_dialogs.dart`
- `C:/Extension/Musify/lib/utilities/song_filtering.dart`
- `C:/Extension/Musify/lib/utilities/app_utils.dart`
- `C:/Extension/Musify/lib/services/update_manager.dart`
- `C:/Extension/Musify/lib/constants/app_constants.dart`
- `C:/Extension/Musify/lib/services/common_services.dart`
- `C:/Extension/Musify/lib/main.dart`
- `C:/Extension/Musify/scripts/checkdb.sh`
- `C:/Extension/Musify/scripts/checker.dart`
- `C:/Extension/Musify/windows/runner/utils.cpp`
- `C:/Extension/Musify/windows/runner/utils.h`

##### getCPUArchitecture() usa uname -m que no existe en Windows
- **Severidad:** critico
- **Archivo:** `C:/Extension/Musify/lib/services/update_manager.dart`:256-261
- **Código:** `Process.run('uname', ['-m'])`
- **Descripción:** uname no existe en Windows. IOException, actualizacion rota.
- **Reproducción:** En Windows, getCPUArchitecture() falla, getDownloadUrl() falla.
- **Test:** Sí (test_unitario)
- **Corrección:** Deteccion multiplataforma con Platform.operatingSystem o wmic.

##### downloadFilename hardcoded como Musify.apk siempre
- **Severidad:** critico
- **Archivo:** `C:/Extension/Musify/lib/services/update_manager.dart`:44
- **Código:** `const String downloadFilename = 'Musify.apk';`
- **Descripción:** Hardcodeado .apk. No hay logica para seleccionar asset Windows.
- **Reproducción:** Download en Windows abre pagina GitHub sin filtrar asset correcto.
- **Test:** No (manual)
- **Corrección:** Usar Platform.isWindows para seleccionar .msix/.exe.

##### Hardcodeo de separador '/' en construccion de rutas
- **Severidad:** alto
- **Archivo:** `C:/Extension/Musify/lib/services/io_service.dart`:36-41
- **Código:** `'$applicationDirPath/$tracksDir/$songId$audioExtension'`
- **Descripción:** Rutas con '/' hardcodeado. Separadores mixtos en Windows.
- **Reproducción:** getAudioPath('abc123') retorna separadores mixtos.
- **Test:** Sí (test_unitario)
- **Corrección:** Usar p.join() del paquete path.

##### Validacion de backup asume nombres de carpeta en ingles
- **Severidad:** medio
- **Archivo:** `C:/Extension/Musify/lib/services/data_manager.dart`:226
- **Código:** `dlPath.contains('Documents')`
- **Descripción:** Falla en Windows espanol (Documentos, Descargas).
- **Reproducción:** Seleccionar Documentos en Windows espanol. Backup rechazado.
- **Test:** Sí (test_unitario)
- **Corrección:** Validar escribible en vez de nombres fijos.

##### ArtworkProvider asume rutas Unix (startsWith('/'))
- **Severidad:** medio
- **Archivo:** `C:/Extension/Musify/lib/utilities/artwork_provider.dart`:50
- **Código:** `artwork.startsWith('file://') || artwork.startsWith('/')`
- **Descripción:** No reconoce rutas Windows como C:\...
- **Reproducción:** offlineSong['artworkPath'] con path Windows no se reconoce como local.
- **Test:** Sí (test_unitario)
- **Corrección:** Incluir deteccion de letra de unidad.

##### No hay permisos runtime declarados para Windows
- **Severidad:** bajo
- **Archivo:** `C:/Extension/Musify/lib/services/common_services.dart`
- **Descripción:** Windows requiere capabilities (InternetClient) no declaradas.
- **Test:** No (manual)
- **Corrección:** Agregar capabilities en AppxManifest.xml.

##### getTemporaryDirectory() sin limpieza del temporal
- **Severidad:** bajo
- **Archivo:** `C:/Extension/Musify/lib/screens/time_machine_page.dart`:289-291
- **Descripción:** Archivo temporal nunca se elimina en Windows.
- **Reproducción:** Compartir Time Machine recap. PNG se acumula en %TEMP%.
- **Test:** No (manual)
- **Corrección:** finally block que elimine el archivo.

##### Separador '/' en scripts de shell no portable
- **Severidad:** bajo
- **Archivo:** `C:/Extension/Musify/scripts/checkdb.sh`:1
- **Descripción:** .sh no funciona en cmd.exe.
- **Reproducción:** checkdb.sh falla en Windows sin Git Bash.
- **Test:** No (manual)
- **Corrección:** Crear .bat companion.

### CICLO DE VIDA Y ESTADO

**Archivos revisados (19):**

- `C:\Extension\Musify\lib\main.dart`
- `C:\Extension\Musify\lib\main_fdroid.dart`
- `C:\Extension\Musify\lib\services\audio_service.dart`
- `C:\Extension\Musify\lib\services\data_manager.dart`
- `C:\Extension\Musify\lib\models\full_player_state.dart`
- `C:\Extension\Musify\lib\models\position_data.dart`
- `C:\Extension\Musify\lib\models\proxy_model.dart`
- `C:\Extension\Musify\lib\models\radio_model.dart`
- `C:\Extension\Musify\lib\services\listening_stats_service.dart`
- `C:\Extension\Musify\lib\services\common_services.dart`
- `C:\Extension\Musify\lib\services\router_service.dart`
- `C:\Extension\Musify\lib\utilities\async_loader.dart`
- `C:\Extension\Musify\lib\utilities\mediaitem.dart`
- `C:\Extension\Musify\lib\widgets\mini_player.dart`
- `C:\Extension\Musify\lib\widgets\queue_list_view.dart`
- `C:\Extension\Musify\lib\screens\now_playing_page.dart`
- `C:\Extension\Musify\lib\screens\home_page.dart`
- `C:\Extension\Musify\lib\constants\version.dart`
- `C:\Extension\Musify\pubspec.yaml`

### INPUT Y EVENTOS - portabilidad Android a Windows

**Archivos revisados (35):** (listados en la seccion de severidad)

### LAYOUT Y DIMENSIONES

**Archivos revisados (0):**


### Portabilidad Android a Windows - BUILD, DEPENDENCIAS Y CONFIGURACION

**Archivos revisados (34):** (listados en la seccion de severidad)

---

## Plan de Prueba Manual

Priorizado por riesgo. Ejecutar en este orden:

**1. [CRITICO] Abrir app, navegar todos los tabs (Home, Search, Library, Settings), verificar que cada pantalla cargue sin crash y los datos se muestren**

**2. [CRITICO] Reproducir una cancion, verificar que el mini player aparezca, tap para abrir Now Playing, verificar artwork, controles, posicion slider**

**3. [CRITICO] Reproducir, minimizar ventana, restaurar. El audio continua? Los controles responden?**

**4. [CRITICO] Redimensionar ventana a distintos tamanos (640x480, 1280x720, 1920x1080, maximizado). Verificar que no haya elementos recortados o solapados**

**5. [ALTO] Probar navegacion por teclado (Tab, Enter, Espacio, flechas) en cada pantalla. Verificar foco visible y orden logico**

**6. [ALTO] Click derecho en listas (playlist, songs, artists). Verificar menu contextual. Probar long press si existe**

**7. [ALTO] Recorrer todas las pantallas. Verificar que todos los iconos se rendericen (no cuadros vacios ni placeholders)**

**8. [ALTO] Buscar canciones/artistas/playlists. Verificar resultados, limpiar busqueda, buscar sin conexion**

**9. [ALTO] Crear playlist, agregar/quitar canciones, renombrar, eliminar. Verificar persistencia al reiniciar**

**10. [ALTO] Navegar a artista, seleccionar cancion, volver atras. Repetir 5 veces. Verificar back stack sin pantallas en blanco**

**11. [MEDIO] Probar modo oscuro/claro. Verificar colores correctos en textos, fondos, iconos**

**12. [MEDIO] Abrir equalizador desde settings, ajustar bandas, verificar que el sonido cambie**

**13. [MEDIO] Abrir estaciones de radio, seleccionar una, verificar reproduccion**

**14. [MEDIO] Importar archivo de audio local. Verificar que aparezca en biblioteca y se pueda reproducir**

**15. [MEDIO] Compartir una cancion. Verificar que se abra interfaz de share de Windows**

**16. [MEDIO] Probar deep links si estan configurados. Verificar que abran pantalla correcta**

**17. [BAJO] Si existe funcionalidad de video, probar reproduccion de video YouTube**

**18. [BAJO] Verificar que el update checker no crashee al buscar nueva version**

---

*Auditoria generada el 2026-07-23 por workflow ultracode con 8 agentes paralelos.*
