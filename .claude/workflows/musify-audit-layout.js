export const meta = {
  name: 'musify-audit-layout',
  description: 'Re-ejecuta solo area Layout y Dimensiones con ruta absoluta',
  phases: [{ title: 'Layout y dimensiones' }, { title: 'Actualizar reporte' }],
}

phase('Layout y dimensiones')
const layoutReport = await agent(
  'Eres auditor portabilidad Android->Windows especializado en LAYOUT.\n' +
  'Proyecto: C:\\Extension\\Musify\\\n\n' +
  'Reglas: SOLO LECTURA. Verifica contra codigo real. No infieras.\n\n' +
  'Revisa estos archivos buscando problemas de layout en Windows:\n' +
  'lib/widgets/{song_bar,artist_bar,playlist_bar,mini_player,queue_list_view,position_slider,sort_chips,spinner,song_artwork,playlist_artwork,no_artwork_cube,playlist_cube,custom_bar,custom_search_bar,bottom_sheet_bar,playback_icon_button,overflow_menu_button,popup_menu_item,radio_station_card,listening_recap_card,announcement_box,auto_format_text,offline_search_placeholder,section_header,section_title}.dart\n' +
  'lib/widgets/now_playing/{now_playing_artwork,now_playing_controls,bottom_actions_row,marquee_text_widget}.dart\n' +
  'lib/widgets/playlist_page/{empty_playlist_state,playlist_header,search_bar_section,shuffle_play_button,playlist_action_buttons}.dart\n' +
  'lib/widgets/background/animated_background.dart\n' +
  'lib/screens/{home_page,search_page,library_page,settings_page,now_playing_page,playlist_page,artist_page,about_page,equalizer_page,radio_stations_page,time_machine_page,user_songs_page,bottom_navigation_page}.dart\n' +
  'lib/theme/{app_colors,app_themes,dynamic_color_compat}.dart\n' +
  'windows/runner/{main.cpp,flutter_window.h,win32_window.h,CMakeLists.txt}\n\n' +
  'Busca:\n' +
  '1. width/height fijos (SizedBox, Container, SizedBox.fromSize) que no escalan al redimensionar ventana.\n' +
  '2. SafeArea que asume notches Android.\n' +
  '3. EdgeInsets/padding fijo en px en vez de proporcional.\n' +
  '4. AspectRatio que asume proporcion movil vertical.\n' +
  '5. Row sin Expanded/Flexible que cause overflow.\n' +
  '6. itemExtent fijo en ListView.builder.\n' +
  '7. LayoutBuilder ausente donde se necesita responsive.\n' +
  '8. Codigo que asume portrait-only.\n' +
  '9. Scroll lists sin soporte rueda mouse.\n' +
  '10. NavigationDrawer sin sidebar alternativa.\n' +
  '11. Window min/max size en C++.\n' +
  '12. Overflow en layouts angostos.\n\n' +
  'IMPORTANTE: Devolve TU RESPUESTA como TEXTO PLANO, NO como JSON ni herramienta estructurada.\n' +
  'Formato por hallazgo:\n' +
  '---\n' +
  'TITULO: <titulo>\n' +
  'SEVERIDAD: <critico|alto|medio|bajo>\n' +
  'ARCHIVO: <path relativo>\n' +
  'LINEA: <numero>\n' +
  'CODIGO: <fragmento>\n' +
  'DESCRIPCION: <descripcion>\n' +
  'REPRODUCCION: <pasos>\n' +
  'TEST: <Si/No> (<tipo>)\n' +
  'CORRECCION: <propuesta>\n' +
  '---\n\n' +
  'Si no hay hallazgos, responde exactamente: SIN HALLAZGOS\n' +
  'Comienza con LISTA DE ARCHIVOS REVISADOS: (lista separada por coma)',
  {phase: 'Layout y dimensiones'}
)

phase('Actualizar reporte')
if (!layoutReport || layoutReport.trim() === 'SIN HALLAZGOS') {
  await agent(
    'AUDITORIA_PORT_WINDOWS.md ya existe en C:\\Extension\\Musify\\.\n' +
    'El area Layout se re-ejecuto y NO tiene hallazgos. No modifiques nada.\n' +
    'Solo verifica que exista el archivo y confirma que esta correcto.',
    {phase: 'Actualizar reporte'}
  )
  return { hallazgos: 0, archivos: 0, nota: 'Sin hallazgos de layout' }
}

// Parse and insert findings
await agent(
  'Lee el archivo C:\\Extension\\Musify\\AUDITORIA_PORT_WINDOWS.md\n\n' +
  'Agrega al inicio de la seccion "## Hallazgos por Severidad" este texto:\n\n' +
  '## Layout y Dimensiones (re-ejecutado)\n\n' +
  'Hallazgos detectados:\n\n' +
  layoutReport +
  '\n\n---\n\n' +
  'Luego actualiza la tabla resumen: la fila "LAYOUT Y DIMENSIONES" actual tiene 0|0|0|0|0, cambiala por los valores correctos segun los hallazgos.\n\n' +
  'Escribe el archivo actualizado.',
  {phase: 'Actualizar reporte'}
)

return { hallazgos: layoutReport ? layoutReport.split('SEVERIDAD:').length - 1 : 0 }
