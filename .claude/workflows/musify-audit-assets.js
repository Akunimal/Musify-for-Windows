export const meta = {
  name: 'musify-audit-assets',
  description: 'Re-ejecuta solo area Assets e Iconos con ruta absoluta',
  phases: [{ title: 'Assets e iconos' }, { title: 'Actualizar reporte' }],
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

phase('Assets e iconos')
const result = await agent(
  'Eres auditor de portabilidad Android a Windows especializado en ASSETS E ICONOS.\n' +
  'Proyecto: Musify (Flutter). Portado de Android a Windows.\n\n' +
  'IMPORTANTE: El proyecto esta en C:\\Extension\\Musify\\ USA RUTAS ABSOLUTAS para leer archivos.\n' +
  'Ejemplo: C:\\Extension\\Musify\\pubspec.yaml, C:\\Extension\\Musify\\lib\\main.dart\n\n' +
  'INSTRUCCIONES ESTRICTAS:\n' +
  '- SOLO LECTURA. No modifiques ni crees archivos.\n' +
  '- Verifica CADA hallazgo contra el codigo real en C:\\Extension\\Musify\\: archivo, linea, fragmento.\n' +
  '- No infieras ni supongas. Si no ves el bug, no lo reportes.\n' +
  '- Clasifica severidad: critico / alto / medio / bajo.\n\n' +
  'Archivos a revisar (usa RUTAS ABSOLUTAS C:\\Extension\\Musify\\ + subruta):\n' +
  '- C:\\Extension\\Musify\\pubspec.yaml\n' +
  '- C:\\Extension\\Musify\\assets\\icons\\musify_icon.png\n' +
  '- C:\\Extension\\Musify\\assets\\fonts\\segoe\\SegoeFluentIcons.ttf\n' +
  '- C:\\Extension\\Musify\\assets\\fonts\\paytone\\PaytoneOne-Regular.ttf\n' +
  '- C:\\Extension\\Musify\\windows\\runner\\resources\\app_icon.ico\n' +
  '- C:\\Extension\\Musify\\windows\\runner\\Runner.rc\n' +
  '- C:\\Extension\\Musify\\windows\\runner\\resource.h\n' +
  '- C:\\Extension\\Musify\\lib\\main.dart\n' +
  '- C:\\Extension\\Musify\\lib\\main_fdroid.dart\n' +
  '- C:\\Extension\\Musify\\lib\\utilities\\app_icon.dart\n' +
  '- C:\\Extension\\Musify\\lib\\theme\\app_themes.dart\n' +
  '- C:\\Extension\\Musify\\lib\\theme\\dynamic_color_compat.dart\n' +
  '- C:\\Extension\\Musify\\lib\\widgets\\song_artwork.dart\n' +
  '- C:\\Extension\\Musify\\lib\\widgets\\playlist_artwork.dart\n' +
  '- C:\\Extension\\Musify\\lib\\widgets\\no_artwork_cube.dart\n' +
  '- C:\\Extension\\Musify\\lib\\widgets\\now_playing\\now_playing_artwork.dart\n' +
  '- C:\\Extension\\Musify\\lib\\utilities\\artwork_provider.dart\n' +
  '- C:\\Extension\\Musify\\android\\app\\src\\main\\res\\ (drawable, mipmap directories)\n\n' +
  'QUE BUSCAR:\n' +
  '1. Icono .ico Windows existe? Tiene multiples tamanios? El .png de assets/ se convirtio?\n' +
  '2. Assets declarados en pubspec.yaml vs assets que existen en disco. Faltan assets?\n' +
  '3. Assets Android (drawable/mipmap) que no tienen equivalente Windows.\n' +
  '4. Audio service icons en Android (drawable/audio_service_*.png) -- existen en Windows?\n' +
  '5. Referencias a rutas de assets en codigo Dart que no existen en disco.\n' +
  '6. El font Segoe Fluent Icons tiene declaracion correcta? Se usa en widgets de Windows?\n' +
  '7. dynamic_color: funciona diferente en Windows que en Android. Hay fallback?\n' +
  '8. app_icon.ico (Windows runner) se genero o es un placeholder? Tamanios incluidos?\n' +
  '9. Android adaptive icons (ic_launcher.xml, ic_launcher_adaptive_fore.png) sin equivalente Windows.\n' +
  '10. android drawable background.png en 3 densidades (night, v21, night-v21) sin equivalente Windows.\n' +
  '11. Flutter pubspec assets declarados: solo "assets/licenses/" y "assets/icons/musify_icon.png". Faltan fonts? Faltan assets de paquetes?\n\n' +
  'Reporta TODOS los hallazgos con archivo:linea exactos y fragmento de codigo.',
  {phase: 'Assets e iconos', schema: FS}
)

phase('Actualizar reporte')
// Build findings section
let assetsSection = '\n\n## Assets e Iconos (re-ejecutado)\n\n'
assetsSection += '**Archivos revisados (' + (result?.archivos_revisados?.length || 0) + '):**\n\n'
for (const f of (result?.archivos_revisados || [])) assetsSection += '- `' + f + '`\n'
assetsSection += '\n'

if (result?.areas_sin_hallazgos) {
  assetsSection += '**Sin hallazgos.** ' + (result?.nota || '') + '\n\n'
} else if (result?.hallazgos && result.hallazgos.length > 0) {
  for (const h of result.hallazgos) {
    assetsSection += '##### ' + h.titulo + '\n'
    assetsSection += '- **Severidad:** ' + h.severidad + '\n'
    assetsSection += '- **Archivo:** `' + h.archivo + '`:' + h.linea + '\n'
    if (h.fragmento) assetsSection += '- **Codigo:**\n```dart\n' + h.fragmento + '\n```\n'
    assetsSection += '- **Descripcion:** ' + h.descripcion + '\n'
    assetsSection += '- **Reproduccion:** ' + h.reproduccion + '\n'
    if (h.detectable_por_test !== undefined) {
      assetsSection += '- **Test:** ' + (h.detectable_por_test ? 'Si' : 'No')
      if (h.tipo_test) assetsSection += ' (' + h.tipo_test + ')'
      assetsSection += '\n'
    }
    if (h.correccion_propuesta) assetsSection += '- **Correccion:** ' + h.correccion_propuesta + '\n'
    assetsSection += '\n'
  }
}

// Read existing report and insert after the summary
await agent(
  '1. Read the file C:\\Extension\\Musify\\AUDITORIA_PORT_WINDOWS.md\n' +
  '2. Find the line "## Hallazgos por Severidad" (it appears right after the summary table)\n' +
  '3. Insert this text right BEFORE "## Hallazgos por Severidad":\n\n' +
  assetsSection +
  '\n\n4. Also update the summary table:\n' +
  '   - If the row for "assets" exists (it has 0|0|0|0|0), replace its values with the correct counts.\n' +
  '   - If no row exists, add a row for "Assets e iconos" with the correct counts.\n' +
  '   - Update the Total row.\n\n' +
  '5. Write the modified content back to C:\\Extension\\Musify\\AUDITORIA_PORT_WINDOWS.md (OVERWRITE).\n\n' +
  'IMPORTANT: Preserve ALL existing content. Only modify the summary table and add the new section.',
  {phase: 'Actualizar reporte'}
)

return {
  hallazgos: result?.hallazgos?.length || 0,
  archivos: result?.archivos_revisados?.length || 0,
}
