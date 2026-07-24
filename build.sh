#!/bin/bash
# Build Musify for Windows — no Developer Mode required
# Usage: bash build.sh

set -e

FLUTTER_ROOT="${FLUTTER_ROOT:-/c/tools/flutter}"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

echo "=== Musify Windows Build ==="

# 1) flutter pub get (creates .dart_tool/package_config.json)
echo "[1/6] flutter pub get..."
"$FLUTTER_ROOT/bin/flutter" pub get 2>&1

# 2) Create plugin symlinks as junctions (bypasses Developer Mode requirement)
echo "[2/6] Creating plugin junctions..."
mkdir -p windows/flutter/ephemeral/.plugin_symlinks

# Read plugin list from generated_plugins.cmake
PLUGINS=$(grep -oP '(?<=^  )\w+(?=\$)' windows/flutter/generated_plugins.cmake 2>/dev/null \
  | grep -v "FLUTTER_PLUGIN_LIST\|FLUTTER_FFI_PLUGIN_LIST\|PLUGIN_BUNDLED_LIBRARIES\|foreach\|endforeach\|add_subdirectory\|target_link_libraries\|list\|endif\|endfunction")
# Fallback: explicit list
if [ -z "$PLUGINS" ]; then
  PLUGINS="app_links dynamic_color just_audio_windows media_kit_libs_windows_video media_kit_video receive_sharing_intent share_plus url_launcher_windows jni"
fi

PUB_CACHE="${PUB_CACHE:-$FLUTTER_ROOT/.pub-cache}"
if [ ! -d "$PUB_CACHE" ]; then
  PUB_CACHE="$FLUTTER_ROOT/cache/.pub-cache"
fi
if [ ! -d "$PUB_CACHE" ]; then
  PUB_CACHE="$HOME/AppData/Local/Pub/Cache"
fi

for plugin in $PLUGINS; do
  target="windows/flutter/ephemeral/.plugin_symlinks/$plugin"
  if [ -d "$target" ] && [ ! -L "$target" ]; then
    echo "  ✓ $plugin already exists"
    continue
  fi

  # Find plugin source in pub cache or local packages
  src=""
  if [ -d "packages/$plugin" ]; then
    src="$(cd "packages/$plugin" && pwd)"
  else
    # Match package with version suffix (e.g. app_links-7.2.1)
    src=$(find "$PUB_CACHE/hosted/pub.dev" -maxdepth 1 -type d -name "${plugin}-*" 2>/dev/null | sort -V | tail -1)
  fi

  if [ -n "$src" ]; then
    # Remove existing symlink/junction if any
    if [ -L "$target" ] || [ -d "$target" ]; then
      rm -rf "$target" 2>/dev/null || cmd.exe /c "rmdir /Q /S \"$(cygpath -w "$target")\"" 2>/dev/null || true
    fi
    # Create junction (Windows directory link, no Developer Mode needed)
    cmd.exe /c "mklink /J \"$(cygpath -w "$target")\" \"$(cygpath -w "$src")\"" 2>/dev/null && echo "  ✓ $plugin" || echo "  ✗ $plugin (symlink failed)"
  else
    echo "  ⚠ $plugin source not found"
  fi
done

# 3) Assemble Flutter assets + app.so
echo "[3/6] flutter assemble..."
"$FLUTTER_ROOT/bin/cache/dart-sdk/bin/dart.exe" \
  --packages="$FLUTTER_ROOT/packages/flutter_tools/.dart_tool/package_config.json" \
  "$FLUTTER_ROOT/bin/cache/flutter_tools.snapshot" \
  assemble --no-version-check \
  -dTargetPlatform=windows-x64 \
  -dBuildMode=release \
  -dTargetFile=lib/main.dart \
  --output=build \
  release_bundle_windows-x64_assets 2>&1

# 4) CMake configure
echo "[4/6] CMake configure..."
cmake -S windows -B build/windows/x64 \
  -G "Visual Studio 17 2022" -A x64 2>&1

# 5) MSBuild
echo "[5/6] MSBuild..."
msbuild build/windows/x64/musify.sln \
  /p:Configuration=Release /p:Platform=x64 /t:Build /m 2>&1

# 6) Bundle dist/
echo "[6/6] Bundling dist/..."
rm -rf dist 2>/dev/null
mkdir -p dist/data

cp build/windows/x64/runner/Release/musify.exe dist/
cp build/windows/x64/runner/Release/*.dll dist/
find build/windows/x64/plugins -name "*.dll" -exec cp {} dist/ \;
cp windows/flutter/ephemeral/flutter_windows.dll dist/ 2>/dev/null || true
cp windows/flutter/ephemeral/icudtl.dat dist/data/ 2>/dev/null || true
cp build/windows/app.so dist/data/ 2>/dev/null || true
cp -r build/flutter_assets/* dist/data/ 2>/dev/null || true

# libmpv-2.dll fallback
if [ ! -f dist/libmpv-2.dll ]; then
  find "$FLUTTER_ROOT" "$HOME/AppData" -name "libmpv-2.dll" 2>/dev/null \
    | head -1 | while read f; do cp "$f" dist/; done
fi

echo ""
echo "=== Build complete ==="
ls -lh dist/musify.exe dist/*.dll 2>/dev/null
echo ""
echo "dist/ ready — run ./dist/musify.exe"