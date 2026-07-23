export const meta = {
  name: 'musify-audit-port-windows',
  description: 'Audita 8 areas de portabilidad Android a Windows en Musify',
  phases: [
    { title: 'Assets e iconos' },
    { title: 'Navegacion y flujos' },
    { title: 'APIs de plataforma' },
    { title: 'Sistema de archivos y rutas' },
    { title: 'Ciclo de vida y estado' },
    { title: 'Input y eventos' },
    { title: 'Layout y dimensiones' },
    { title: 'Build, dependencias y configuracion' },
    { title: 'Sintesis' },
  ],
}

const FS = {
  type: 'object',
  properties: {
    area: { type: 'string' },
    archivos_revisados: { type: 'array', items: { type: 'string' } },
    hallazgos: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          titulo: { type: 'string' },
          severidad: { type: 'string', enum: ['critico', 'alto', 'medio', 'bajo'] },
          archivo: { type: 'string' },
          linea: { type: 'string' },
          fragmento: { type: 'string' },
          descripcion: { type: 'string' },
          reproduccion: { type: 'string' },
          detectable_por_test: { type: 'boolean' },
          tipo_test: { type: 'string', enum: ['test_unitario', 'test_integracion', 'test_widget', 'manual', 'test_automatizado_e2e'] },
          correccion_propuesta: { type: 'string' },
        },
        required: ['titulo', 'severidad', 'archivo', 'linea', 'descripcion', 'reproduccion'],
      },
    },
    areas_sin_hallazgos: { type: 'boolean' },
    nota: { type: 'string' },
  },
  required: ['area', 'archivos_revisados', 'hallazgos'],
}

const FILES_1 = [
  'pubspec.yaml',
  'assets/icons/musify_icon.png',
  'assets/fonts/segoe/SegoeFluentIcons.ttf',
  'assets/fonts/paytone/PaytoneOne-Regular.ttf',
  'windows/runner/resources/app_icon.ico',
  'windows/runner/Runner.rc',
  'windows/runner/resource.h',
  'lib/main.dart',
  'lib/main_fdroid.dart',
  'lib/utilities/app_icon.dart',
  'lib/theme/app_themes.dart',
  'lib/theme/dynamic_color_compat.dart',
  'lib/widgets/song_artwork.dart',
  'lib/widgets/playlist_artwork.dart',
  'lib/widgets/no_artwork_cube.dart',
  'lib/widgets/now_playing/now_playing_artwork.dart',
  'lib/utilities/artwork_provider.dart',
  'android/app/src/main/res/',
]

const FILES_2 = [
  'lib/main.dart',
  'lib/screens/bottom_navigation_page.dart',
  'lib/screens/home_page.dart',
  'lib/screens/search_page.dart',
  'lib/screens/library_page.dart',
  'lib/screens/settings_page.dart',
  'lib/screens/now_playing_page.dart',
  'lib/screens/playlist_page.dart',
  'lib/screens/playlist_folder_page.dart',
  'lib/screens/artist_page.dart',
  'lib/screens/about_page.dart',
  'lib/screens/equalizer_page.dart',
  'lib/screens/radio_stations_page.dart',
  'lib/screens/time_machine_page.dart',
  'lib/screens/user_songs_page.dart',
  'lib/services/router_service.dart',
  'lib/widgets/mini_player.dart',
  'lib/widgets/bottom_sheet_bar.dart',
]

const FILES_3 = [
  'lib/services/audio_service.dart',
  'lib/services/io_service.dart',
  'lib/services/common_services.dart',
  'lib/services/data_manager.dart',
  'lib/services/logger_service.dart',
  'lib/services/settings_manager.dart',
  'lib/services/update_manager.dart',
  'lib/services/video_bridge.dart',
  'lib/services/proxy_manager.dart',
  'lib/services/lyrics_manager.dart',
  'lib/services/listening_stats_service.dart',
  'lib/services/playlist_download_service.dart',
  'lib/services/playlist_sharing.dart',
  'lib/services/playlists_manager.dart',
  'lib/services/artist_service.dart',
  'lib/services/router_service.dart',
  'lib/utilities/url_launcher.dart',
  'lib/utilities/sharing_intent.dart',
  'lib/utilities/flutter_toast.dart',
  'lib/utilities/playlist_image_picker.dart',
  'lib/utilities/offline_playlist_dialogs.dart',
  'lib/utilities/mediaitem.dart',
  'lib/constants/clients.dart',
  'windows/runner/main.cpp',
  'windows/runner/flutter_window.cpp',
  'windows/runner/win32_window.cpp',
  'windows/runner/utils.cpp',
  'packages/receive_sharing_intent/lib/receive_sharing_intent.dart',
]

const FILES_4 = [
  'lib/services/io_service.dart',
  'lib/services/data_manager.dart',
  'lib/database/albums.db.dart',
  'lib/database/playlists.db.dart',
  'lib/database/radio_stations.db.dart',
  'lib/services/settings_manager.dart',
  'lib/services/playlist_download_service.dart',
  'lib/services/playlists_manager.dart',
  'lib/utilities/playlist_image_picker.dart',
  'lib/utilities/offline_playlist_dialogs.dart',
  'lib/utilities/song_filtering.dart',
  'lib/utilities/app_utils.dart',
  'lib/services/update_manager.dart',
  'lib/constants/app_constants.dart',
  'lib/services/common_services.dart',
  'lib/main.dart',
  'scripts/checkdb.sh',
  'scripts/checker.dart',
  'windows/runner/utils.cpp',
  'windows/runner/utils.h',
]

const FILES_5 = [
  'lib/main.dart',
  'lib/main_fdroid.dart',
  'lib/services/audio_service.dart',
  'lib/services/data_manager.dart',
  'lib/models/full_player_state.dart',
  'lib/models/position_data.dart',
  'lib/models/proxy_model.dart',
  'lib/models/radio_model.dart',
  'lib/services/listening_stats_service.dart',
  'lib/services/common_services.dart',
  'lib/services/router_service.dart',
  'lib/utilities/async_loader.dart',
  'lib/utilities/mediaitem.dart',
  'lib/widgets/mini_player.dart',
  'lib/widgets/queue_list_view.dart',
  'lib/screens/now_playing_page.dart',
  'lib/screens/home_page.dart',
  'lib/constants/version.dart',
]

const FILES_6 = [
  'lib/widgets/custom_bar.dart',
  'lib/widgets/custom_search_bar.dart',
  'lib/widgets/bottom_sheet_bar.dart',
  'lib/widgets/position_slider.dart',
  'lib/widgets/playback_icon_button.dart',
  'lib/widgets/overflow_menu_button.dart',
  'lib/widgets/popup_menu_item.dart',
  'lib/widgets/song_bar.dart',
  'lib/widgets/artist_bar.dart',
  'lib/widgets/playlist_bar.dart',
  'lib/widgets/mini_player.dart',
  'lib/widgets/mini_player_bottom_space.dart',
  'lib/widgets/now_playing/now_playing_controls.dart',
  'lib/widgets/now_playing/bottom_actions_row.dart',
  'lib/widgets/now_playing/marquee_text_widget.dart',
  'lib/widgets/playlist_page/playlist_action_buttons.dart',
  'lib/widgets/playlist_page/shuffle_play_button.dart',
  'lib/widgets/queue_list_view.dart',
  'lib/widgets/radio_station_card.dart',
  'lib/widgets/sort_chips.dart',
  'lib/widgets/confirmation_dialog.dart',
  'lib/widgets/edit_playlist_dialog.dart',
  'lib/widgets/rename_song_dialog.dart',
  'lib/widgets/dialog_item.dart',
  'lib/widgets/video/video_test_widget.dart',
  'lib/widgets/video/youtube_video_player.dart',
  'lib/widgets/playlist_cube.dart',
  'lib/widgets/spinner.dart',
  'lib/widgets/flutter_bottom_sheet.dart',
  'lib/widgets/marquee.dart',
  'lib/widgets/section_header.dart',
  'lib/widgets/section_title.dart',
  'lib/utilities/app_icon.dart',
  'windows/runner/win32_window.cpp',
  'windows/runner/win32_window.h',
  'windows/runner/flutter_window.cpp',
]

const FILES_7 = [
  'lib/theme/app_colors.dart',
  'lib/theme/app_themes.dart',
  'lib/theme/dynamic_color_compat.dart',
  'lib/widgets/song_bar.dart',
  'lib/widgets/artist_bar.dart',
  'lib/widgets/playlist_bar.dart',
  'lib/widgets/no_artwork_cube.dart',
  'lib/widgets/playlist_cube.dart',
  'lib/widgets/playlist_artwork.dart',
  'lib/widgets/song_artwork.dart',
  'lib/widgets/mini_player.dart',
  'lib/widgets/now_playing/now_playing_artwork.dart',
  'lib/widgets/now_playing/now_playing_controls.dart',
  'lib/widgets/now_playing/bottom_actions_row.dart',
  'lib/widgets/now_playing/marquee_text_widget.dart',
  'lib/widgets/position_slider.dart',
  'lib/widgets/bottom_sheet_bar.dart',
  'lib/widgets/custom_bar.dart',
  'lib/widgets/custom_search_bar.dart',
  'lib/widgets/playback_icon_button.dart',
  'lib/widgets/overflow_menu_button.dart',
  'lib/widgets/popup_menu_item.dart',
  'lib/widgets/queue_list_view.dart',
  'lib/widgets/radio_station_card.dart',
  'lib/widgets/announcement_box.dart',
  'lib/widgets/auto_format_text.dart',
  'lib/widgets/background/animated_background.dart',
  'lib/widgets/listening_recap_card.dart',
  'lib/widgets/section_header.dart',
  'lib/widgets/section_title.dart',
  'lib/widgets/spinner.dart',
  'lib/widgets/playlist_page/empty_playlist_state.dart',
  'lib/widgets/playlist_page/playlist_header.dart',
  'lib/widgets/playlist_page/search_bar_section.dart',
  'lib/widgets/playlist_page/shuffle_play_button.dart',
  'lib/widgets/playlist_page/playlist_action_buttons.dart',
  'lib/widgets/offline_search_placeholder.dart',
  'lib/screens/home_page.dart',
  'lib/screens/search_page.dart',
  'lib/screens/library_page.dart',
  'lib/screens/settings_page.dart',
  'lib/screens/now_playing_page.dart',
  'lib/screens/playlist_page.dart',
  'lib/screens/artist_page.dart',
  'lib/screens/about_page.dart',
  'lib/screens/equalizer_page.dart',
  'lib/screens/radio_stations_page.dart',
  'lib/screens/time_machine_page.dart',
  'lib/screens/user_songs_page.dart',
  'lib/screens/bottom_navigation_page.dart',
  'windows/runner/main.cpp',
  'windows/runner/flutter_window.h',
  'windows/runner/win32_window.h',
  'windows/runner/CMakeLists.txt',
]

const FILES_8 = [
  'pubspec.yaml',
  'pubspec.lock',
  'windows/CMakeLists.txt',
  'windows/flutter/CMakeLists.txt',
  'windows/flutter/generated_plugins.cmake',
  'windows/flutter/generated_plugin_registrant.cc',
  'windows/flutter/generated_plugin_registrant.h',
  'windows/runner/CMakeLists.txt',
  'windows/runner/main.cpp',
  'windows/runner/runner.exe.manifest',
  'windows/runner/Runner.rc',
  'windows/runner/resource.h',
  'windows/runner/utils.h',
  'android/app/build.gradle.kts',
  'android/build.gradle.kts',
  'android/settings.gradle.kts',
  'android/gradle.properties',
  'analysis_options.yaml',
  'crowdin.yml',
  'l10n.yaml',
  'update.sh',
  '.metadata',
  '.gitignore',
  'packages/receive_sharing_intent/pubspec.yaml',
  'packages/youtube_explode_dart/pubspec.yaml',
  'packages/youtube_music_explode_dart/pubspec.yaml',
]

phase('Assets e iconos')
const a1 = await agent(
  'Eres auditor de portabilidad Android a Windows especializado en ASSETS E ICONOS.\n' +
  'Proyecto: Musify (Flutter). Portado de Android a Windows.\n\n' +
  'INSTRUCCIONES ESTRICTAS:\n' +
  '- SOLO LECTURA. No modifiques ni crees archivos.\n' +
  '- Verifica CADA hallazgo contra codigo real: archivo, linea, fragmento.\n' +
  '- No infieras ni supongas. Si no ves el bug, no lo reportes.\n' +
  '- Clasifica severidad: critico / alto / medio / bajo.\n\n' +
  'Archivos a revisar:\n' + JSON.stringify(FILES_1, null, 2) + '\n\n' +
  'QUE BUSCAR:\n' +
  '1. Icono .ico Windows existe? Tiene multiples tamanios? El .png de assets/ se convirtio?\n' +
  '2. Assets declarados en pubspec.yaml vs assets que existen en disco. Faltan assets?\n' +
  '3. Assets Android (drawable/mipmap) que no tienen equivalente Windows.\n' +
  '4. Audio service icons en Android (drawable/audio_service_*.png) -- existen en Windows? Flutter los usa cross-platform o solo Android?\n' +
  '5. Referencias a rutas de assets en codigo Dart que no existen en disco.\n' +
  '6. El font Segoe Fluent Icons tiene declaracion correcta? Se usa en widgets de Windows?\n' +
  '7. dynamic_color: funciona diferente en Windows que en Android. Hay fallback?\n' +
  '8. app_icon.ico (Windows runner) se genero o es un placeholder? Tamanios incluidos?\n' +
  '9. Android adaptive icons (ic_launcher.xml, ic_launcher_adaptive_fore.png) sin equivalente Windows.\n' +
  '10. Imagenes de fondo (background.png) en multiples variantes Android que no existen en Windows.\n\n' +
  'Reporta TODOS los hallazgos con archivo:linea exactos y fragmento de codigo que demuestra el problema.',
  {phase: 'Assets e iconos', schema: FS}
)

phase('Navegacion y flujos')
const a2 = await agent(
  'Eres auditor de portabilidad Android a Windows especializado en NAVEGACION Y FLUJOS.\n' +
  'Proyecto: Musify (Flutter). Portado de Android a Windows.\n\n' +
  'INSTRUCCIONES ESTRICTAS: SOLO LECTURA. Verifica cada hallazgo contra codigo real.\n\n' +
  'Archivos a revisar:\n' + JSON.stringify(FILES_2, null, 2) + '\n\n' +
  'QUE BUSCAR:\n' +
  '1. go_router config: rutas definidas vs pantallas implementadas. Faltan registros de ruta?\n' +
  '2. Bottom navigation: tabs funcionales? Index correcto? Hay pantalla que no se alcanza desde ningun tab?\n' +
  '3. Back button behavior en Windows: hardware back en Android vs boton X/Cerrar en Windows. Como maneja el back stack?\n' +
  '4. Deep links / app_links: app_links plugin funciona en Windows? Hay stub vacio?\n' +
  '5. Pantallas que requieren datos iniciales (artist_page, playlist_page): que pasa si se navega sin datos?\n' +
  '6. Navegacion desde mini_player a now_playing: funciona? Hay estado compartido?\n' +
  '7. Search: flujo completo? Search page recibe query correctamente?\n' +
  '8. Bottom sheet: flutter_bottom_sheet.dart usa platform channel? Funciona en Windows?\n' +
  '9. Transiciones entre pantallas: animaciones Android-specific que no renderizan en Windows?\n' +
  '10. Rutas muertas: codigo que referencia rutas no definidas en el router.\n\n' +
  'Reporta hallazgos con archivo:linea exactos.',
  {phase: 'Navegacion y flujos', schema: FS}
)

phase('APIs de plataforma')
const a3 = await agent(
  'Eres auditor de portabilidad Android a Windows especializado en APIs DE PLATAFORMA.\n' +
  'Proyecto: Musify (Flutter). Portado de Android a Windows.\n\n' +
  'INSTRUCCIONES ESTRICTAS: SOLO LECTURA. Verifica cada hallazgo contra codigo real.\n\n' +
  'Archivos a revisar:\n' + JSON.stringify(FILES_3, null, 2) + '\n\n' +
  'QUE BUSCAR:\n' +
  '1. audio_service plugin: funciona en Windows? Requiere setup especial en C++?\n' +
  '2. just_audio_windows: esta correctamente declarado y configurado?\n' +
  '3. media_kit + media_kit_video + media_kit_libs_windows_video: setup completo en Windows?\n' +
  '4. receive_sharing_intent (package custom): tiene implementacion Windows o solo Android/iOS? Si no, silencia el error?\n' +
  '5. url_launcher: funciona en Windows? Usa Platform.isWindows? Hay alternativa?\n' +
  '6. path_provider: rutas correctas en Windows? Directorios que no existen en Windows?\n' +
  '7. file_picker: funciona en Windows? Dialogs nativos?\n' +
  '8. share_plus: funciona en Windows o tira exception silenciada?\n' +
  '9. Platform checks en codigo: Platform.isAndroid usado sin Platform.isWindows alternativo?\n' +
  '10. dart:io vs dart:html: codigo que usa dart:html (no disponible en Windows desktop)?\n' +
  '11. Method channels: llamadas nativas Android sin equivalente Windows?\n' +
  '12. try/catch genericos que silencian excepciones de plataforma no soportada?\n\n' +
  'Reporta hallazgos con archivo:linea exactos.',
  {phase: 'APIs de plataforma', schema: FS}
)

phase('Sistema de archivos y rutas')
const a4 = await agent(
  'Eres auditor de portabilidad Android a Windows especializado en SISTEMA DE ARCHIVOS Y RUTAS.\n' +
  'Proyecto: Musify (Flutter). Portado de Android a Windows.\n\n' +
  'INSTRUCCIONES ESTRICTAS: SOLO LECTURA. Verifica cada hallazgo contra codigo real.\n\n' +
  'Archivos a revisar:\n' + JSON.stringify(FILES_4, null, 2) + '\n\n' +
  'QUE BUSCAR:\n' +
  '1. Separadores de ruta: \'/\' hardcodeado vs Platform.pathSeparator. Windows usa \'\\\'.\n' +
  '2. path_provider: getApplicationDocumentsDirectory() en Windows apunta a %APPDATA%. Codigo que asume estructura tipo Android (/data/data/...)?\n' +
  '3. Rutas absolutas hardcodeadas estilo Android.\n' +
  '4. Directorios temporales: getTemporaryDirectory() existe pero permisos diferentes en Windows.\n' +
  '5. Hive DB: path de almacenamiento. Compatible con Windows paths?\n' +
  '6. Archivos de base de datos en ubicaciones que requieren permisos en Windows.\n' +
  '7. Permisos: Android runtime permissions vs Windows. Codigo que pide permisos Android pero no en Windows.\n' +
  '8. Downloads/SDCard: referencias a almacenamiento externo (Android) que no existe en Windows.\n' +
  '9. File separators en strings de SQL o shell scripts.\n' +
  '10. Launcher update manager: descarga e instalacion de updates -- path de descarga ejecutable en Windows.\n\n' +
  'Reporta hallazgos con archivo:linea exactos.',
  {phase: 'Sistema de archivos y rutas', schema: FS}
)

phase('Ciclo de vida y estado')
const a5 = await agent(
  'Eres auditor de portabilidad Android a Windows especializado en CICLO DE VIDA Y ESTADO.\n' +
  'Proyecto: Musify (Flutter). Portado de Android a Windows.\n\n' +
  'INSTRUCCIONES ESTRICTAS: SOLO LECTURA. Verifica cada hallazgo contra codigo real.\n\n' +
  'Archivos a revisar:\n' + JSON.stringify(FILES_5, null, 2) + '\n\n' +
  'QUE BUSCAR:\n' +
  '1. Ciclo de vida Android (onResume/onPause/onStop) vs Windows. Codigo que depende de Activity lifecycle.\n' +
  '2. audio_service: el plugin tiene su propio lifecycle. Como maneja Windows (no hay Activities)?\n' +
  '3. Guardado/restauracion de estado: WidgetsBindingObserver, didChangeAppLifecycleState.\n' +
  '4. AppLifecycleState en Windows: paused/inactive/resumed son diferentes a Android. Codigo que asume Android semantics.\n' +
  '5. State management: como se mantiene el estado del reproductor entre pantallas. Hay perdida de estado al minimizar/restaurar ventana?\n' +
  '6. Hive: cierre/abierto de DB en lifecycle. Cierre correcto en Windows?\n' +
  '7. AsyncLoader: maneja correctamente estados de carga, error, vacio en Windows o asume comportamiento Android?\n' +
  '8. Isolates: Dart isolates para background audio. Funcionan igual en Windows?\n' +
  '9. Service shutdown: al cerrar ventana Windows, los servicios se detienen ordenadamente?\n' +
  '10. Main.dart: configuracion de flutter_foreground_task o similar Android-only?\n\n' +
  'Reporta hallazgos con archivo:linea exactos.',
  {phase: 'Ciclo de vida y estado', schema: FS}
)

phase('Input y eventos')
const a6 = await agent(
  'Eres auditor de portabilidad Android a Windows especializado en INPUT Y EVENTOS.\n' +
  'Proyecto: Musify (Flutter). Portado de Android a Windows.\n\n' +
  'INSTRUCCIONES ESTRICTAS: SOLO LECTURA. Verifica cada hallazgo contra codigo real.\n\n' +
  'Archivos a revisar:\n' + JSON.stringify(FILES_6, null, 2) + '\n\n' +
  'QUE BUSCAR:\n' +
  '1. GestureDetector/InkWell que dependen de tactil (tap vs click). En Windows mouse events son diferentes.\n' +
  '2. Hover effects: widgets que usan onHover? En Android no existe, en Windows es esencial.\n' +
  '3. Focus: FocusNode, FocusScope, FocusTraversalGroup. En Windows el usuario navega con Tab/Shift+Tab.\n' +
  '4. Keyboard shortcuts: hardware keyboard en Windows no tiene equivalente en Android. El reproductor deberia responder a teclas multimedia.\n' +
  '5. Scroll inertia: ScrollPhysics en Android vs Windows. Momentum scroll diferente.\n' +
  '6. Drag and drop: gestures de arrastrar en playlist. En Windows mouse drag vs touch drag.\n' +
  '7. Right-click: context menus Android (long press) vs Windows (right click). Codigo que solo maneja long press.\n' +
  '8. Tooltips: ausencia de tooltips en widgets interactivos para Windows.\n' +
  '9. Resize events: la ventana redimensionable en Windows requiere LayoutBuilder y Expanded, no tamanios fijos.\n' +
  '10. Windows runners: win32_window.cpp maneja mensajes WM_SIZE, WM_KEYDOWN, etc.\n\n' +
  'Reporta hallazgos con archivo:linea exactos.',
  {phase: 'Input y eventos', schema: FS}
)

phase('Layout y dimensiones')
const a7 = await agent(
  'Eres auditor de portabilidad Android a Windows especializado en LAYOUT Y DIMENSIONES.\n' +
  'Proyecto: Musify (Flutter). Portado de Android a Windows.\n\n' +
  'INSTRUCCIONES ESTRICTAS: SOLO LECTURA. Verifica cada hallazgo contra codigo real.\n\n' +
  'Archivos a revisar:\n' + JSON.stringify(FILES_7, null, 2) + '\n\n' +
  'QUE BUSCAR:\n' +
  '1. Tamanios fijos (SizedBox, Container con width/height hardcodeado en px) que no escalan en ventana redimensionable.\n' +
  '2. MediaQuery usage: usan orientation, size para adaptarse a ventana redimensionable?\n' +
  '3. LayoutBuilder vs tamanios fijos: componentes que deberian ser responsive pero usan tamanios Android-fixed.\n' +
  '4. SafeArea: asume notches Android/status bar. En Windows no hay notches.\n' +
  '5. Density-independent pixels: devicePixelRatio usado correctamente?\n' +
  '6. Orientacion: codigo que asume portrait-only para movil.\n' +
  '7. Scrollable lists que no funcionan con mouse wheel.\n' +
  '8. Window minimum/maximum size definido en Windows runner C++.\n' +
  '9. Dialog y bottom sheet tamanios: en Android son full-screen, en Windows deberian ser redimensionables.\n' +
  '10. Sidebar/drawer: Android usa NavigationDrawer. En Windows se espera sidebar persistente.\n\n' +
  'Reporta hallazgos con archivo:linea exactos.',
  {phase: 'Layout y dimensiones', schema: FS}
)

phase('Build, dependencias y configuracion')
const a8 = await agent(
  'Eres auditor de portabilidad Android a Windows especializado en BUILD, DEPENDENCIAS Y CONFIGURACION.\n' +
  'Proyecto: Musify (Flutter). Portado de Android a Windows.\n\n' +
  'INSTRUCCIONES ESTRICTAS: SOLO LECTURA. Verifica cada hallazgo contra codigo real.\n\n' +
  'Archivos a revisar:\n' + JSON.stringify(FILES_8, null, 2) + '\n\n' +
  'QUE BUSCAR:\n' +
  '1. Dependencias Android-only en pubspec: paquetes sin soporte Windows declarado.\n' +
  '2. generated_plugins.cmake: lista todos los plugins Windows correctamente? Faltan algunos?\n' +
  '3. Divergencia entre config Android y Windows: minSdk, targetSdk vs Windows equivalentes.\n' +
  '4. Lints desactivados (analysis_options.yaml): que reglas se silenciaron? Errores que esconden bugs?\n' +
  '5. CI/CD: GitHub Actions build para Windows existe? Solo Android?\n' +
  '6. Version mismatch: version en pubspec vs codigo (version.dart).\n' +
  '7. Runner.rc: metadatos Windows correctos (icono, nombre, version, descripcion)?\n' +
  '8. Update script: update.sh funciona en Windows? Bash script asume Linux.\n' +
  '9. quality_gate.ps1: PowerShell script. Contenido?\n' +
  '10. Crowdin: config de traducciones, incluye strings de Windows?\n' +
  '11. Packages custom (receive_sharing_intent): tiene soporte Windows o solo Android/iOS?\n' +
  '12. .gitignore: excluye archivos que deberian trackearse para build Windows?\n\n' +
  'Reporta hallazgos con archivo:linea exactos.',
  {phase: 'Build, dependencias y configuracion', schema: FS}
)

// Collect all results
phase('Sintesis')
const allResults = [a1, a2, a3, a4, a5, a6, a7, a8].filter(r => r !== null && r !== undefined)

const severityOrder = ['critico', 'alto', 'medio', 'bajo']
const severityLabel = { critico: 'Crítico', alto: 'Alto', medio: 'Medio', bajo: 'Bajo' }

// Build counts
let md = '# Auditoría de Portabilidad Android → Windows\n\n'
md += '**Proyecto:** Musify\n'
md += '**Fecha:** 2026-07-23\n'
md += '**Propósito:** Identificar problemas de portabilidad en migración de Android a Windows.\n'
md += '**Alcance:** 8 áreas auditadas en paralelo. Cada hallazgo verificado contra código fuente.\n\n---\n\n## Resumen\n\n'
md += '| Área | Archivos Revisados | Crítico | Alto | Medio | Bajo |\n'
md += '|------|----|---------|------|-------|------|\n'

const sevCounts = {}
let totCritical = 0, totHigh = 0, totMed = 0, totLow = 0, totFiles = 0
for (const r of allResults) {
  if (!r || !r.hallazgos) continue
  const c = { critico: 0, alto: 0, medio: 0, bajo: 0 }
  for (const h of r.hallazgos) { if (c[h.severidad] !== undefined) c[h.severidad]++ }
  sevCounts[r.area] = c
  totCritical += c.critico; totHigh += c.alto; totMed += c.medio; totLow += c.bajo
  const fc = (r.archivos_revisados || []).length; totFiles += fc
  md += '| ' + r.area + ' | ' + fc + ' | ' + c.critico + ' | ' + c.alto + ' | ' + c.medio + ' | ' + c.bajo + ' |\n'
}
md += '| **Total** | **' + totFiles + '** | **' + totCritical + '** | **' + totHigh + '** | **' + totMed + '** | **' + totLow + '** |\n\n'
md += '---\n\n## Hallazgos por Severidad\n\n'

for (const sev of severityOrder) {
  const items = []
  for (const r of allResults) {
    if (!r || !r.hallazgos) continue
    for (const h of r.hallazgos) {
      if (h.severidad === sev) items.push({ h, area: r.area })
    }
  }
  if (items.length === 0) continue
  md += '### ' + severityLabel[sev] + ' (' + items.length + ')\n\n'
  for (const { h, area } of items) {
    md += '#### ' + h.titulo + '\n\n'
    md += '- **Área:** ' + area + '\n'
    md += '- **Archivo:** `' + h.archivo + '` línea ' + h.linea + '\n'
    if (h.fragmento) md += '- **Fragmento:** `' + (h.fragmento.length > 200 ? h.fragmento.substring(0, 200) + '...' : h.fragmento) + '`\n'
    md += '- **Descripción:** ' + h.descripcion + '\n'
    md += '- **Reproducción:** ' + h.reproduccion + '\n'
    if (h.detectable_por_test !== undefined) {
      md += '- **Detectable por test:** ' + (h.detectable_por_test ? 'Sí' : 'No')
      if (h.tipo_test) md += ' (' + h.tipo_test + ')'
      md += '\n'
    }
    if (h.correccion_propuesta) md += '- **Corrección propuesta:** ' + h.correccion_propuesta + '\n'
    md += '\n'
  }
}

md += '---\n\n## Hallazgos por Área\n\n'
for (const r of allResults) {
  md += '### ' + r.area + '\n\n'
  md += '**Archivos revisados (' + (r.archivos_revisados || []).length + '):**\n\n'
  for (const f of (r.archivos_revisados || [])) md += '- `' + f + '`\n'
  md += '\n'
  if (r.areas_sin_hallazgos) { md += '**Sin hallazgos.** ' + (r.nota || '') + '\n\n'; continue }
  if (r.hallazgos && r.hallazgos.length > 0) {
    for (const h of r.hallazgos) {
      md += '##### ' + h.titulo + '\n'
      md += '- **Severidad:** ' + h.severidad + '\n'
      md += '- **Archivo:** `' + h.archivo + '`:' + h.linea + '\n'
      if (h.fragmento) md += '- **Código:**\n```dart\n' + h.fragmento + '\n```\n'
      md += '- **Descripción:** ' + h.descripcion + '\n'
      md += '- **Reproducción:** ' + h.reproduccion + '\n'
      if (h.detectable_por_test !== undefined) {
        md += '- **Test:** ' + (h.detectable_por_test ? 'Sí' : 'No')
        if (h.tipo_test) md += ' (' + h.tipo_test + ')'
        md += '\n'
      }
      if (h.correccion_propuesta) md += '- **Corrección:** ' + h.correccion_propuesta + '\n'
      md += '\n'
    }
  }
}

md += '---\n\n## Plan de Prueba Manual\n\n'
md += 'Priorizado por riesgo. Ejecutar en este orden:\n\n'
const tests = [
  { n: '1', r: 'crítico', a: 'Navegación', d: 'Abrir app, navegar todos los tabs (Home, Search, Library, Settings), verificar que cada pantalla cargue sin crash y los datos se muestren' },
  { n: '2', r: 'crítico', a: 'Reproductor', d: 'Reproducir una canción, verificar que el mini player aparezca, tap para abrir Now Playing, verificar artwork, controles, posición slider' },
  { n: '3', r: 'crítico', a: 'Audio', d: 'Reproducir, minimizar ventana, restaurar. El audio continúa? Los controles responden?' },
  { n: '4', r: 'crítico', a: 'Layout', d: 'Redimensionar ventana a distintos tamaños (640x480, 1280x720, 1920x1080, maximizado). Verificar que no haya elementos recortados o solapados' },
  { n: '5', r: 'alto', a: 'Input', d: 'Probar navegación por teclado (Tab, Enter, Espacio, flechas) en cada pantalla. Verificar foco visible y orden lógico' },
  { n: '6', r: 'alto', a: 'Input', d: 'Click derecho en listas (playlist, songs, artists). Verificar menú contextual. Probar long press si existe' },
  { n: '7', r: 'alto', a: 'Iconos', d: 'Recorrer todas las pantallas. Verificar que todos los iconos se rendericen (no cuadros vacíos ni placeholders)' },
  { n: '8', r: 'alto', a: 'Búsqueda', d: 'Buscar canciones/artistas/playlists. Verificar resultados, limpiar búsqueda, buscar sin conexión' },
  { n: '9', r: 'alto', a: 'Playlist', d: 'Crear playlist, agregar/quitar canciones, renombrar, eliminar. Verificar persistencia al reiniciar' },
  { n: '10', r: 'alto', a: 'Navegación', d: 'Navegar a artista, seleccionar canción, volver atrás. Repetir 5 veces. Verificar back stack sin pantallas en blanco' },
  { n: '11', r: 'medio', a: 'Layout', d: 'Probar modo oscuro/claro. Verificar colores correctos en textos, fondos, iconos' },
  { n: '12', r: 'medio', a: 'Equalizador', d: 'Abrir equalizador desde settings, ajustar bandas, verificar que el sonido cambie' },
  { n: '13', r: 'medio', a: 'Radio', d: 'Abrir estaciones de radio, seleccionar una, verificar reproducción' },
  { n: '14', r: 'medio', a: 'Archivos', d: 'Importar archivo de audio local. Verificar que aparezca en biblioteca y se pueda reproducir' },
  { n: '15', r: 'medio', a: 'Compartir', d: 'Compartir una canción. Verificar que se abra interfaz de share de Windows' },
  { n: '16', r: 'medio', a: 'Navegación', d: 'Probar deep links si están configurados. Verificar que abran pantalla correcta' },
  { n: '17', r: 'bajo', a: 'Video', d: 'Si existe funcionalidad de video, probar reproducción de video YouTube' },
  { n: '18', r: 'bajo', a: 'Actualización', d: 'Verificar que el update checker no crashee al buscar nueva versión' },
]
for (const t of tests) {
  md += '**' + t.n + '. [' + t.r.toUpperCase() + '] ' + t.d + '**\n   Área: ' + t.a + '\n\n'
}

md += '---\n\n*Auditoría generada el 2026-07-23 por workflow ultracode con 8 agentes paralelos.*\n'

// Write report
await agent(
  'Write the following content to /c/Extension/Musify/AUDITORIA_PORT_WINDOWS.md (OVERWRITE if exists):\n\n' + md,
  {phase: 'Sintesis'}
)

return {
  totalHallazgos: allResults.reduce((a, r) => a + (r?.hallazgos?.length || 0), 0),
  areasCompletadas: allResults.length,
  criticos: totCritical,
  altos: totHigh,
  medios: totMed,
  bajos: totLow,
}
