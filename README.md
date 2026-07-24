<div align="center">
<img src="https://github.com/gokadzev/Musify/raw/master/.github/assets/Musify-banner.png" width="100%">

> **⚠️ WORK IN PROGRESS** — Este port está en desarrollo activo. Podés encontrar bugs, features faltantes o comportamiento inesperado. Si descargás el .exe, esperá updates frecuentes.

# Musify for Windows 🪟

**Portable native Windows app** — No installation required. Download, extract and run.

[![Stars](https://img.shields.io/github/stars/Akunimal/Musify-for-Windows?style=flat-square&color=D3BEAB)](https://github.com/Akunimal/Musify-for-Windows/stargazers)
[![Downloads](https://img.shields.io/github/downloads/Akunimal/Musify-for-Windows/total?style=flat-square&color=D3BEAB)](https://github.com/Akunimal/Musify-for-Windows/releases)
[![License](https://img.shields.io/github/license/Akunimal/Musify-for-Windows?color=D3BEAB)](LICENSE)
[![Build](https://github.com/Akunimal/Musify-for-Windows/actions/workflows/windows-release.yml/badge.svg)](https://github.com/Akunimal/Musify-for-Windows/actions)

---

## ⬇️ Download

**Musify for Windows is fully portable** — no installer, no registry changes, no admin rights needed.

1. Go to the [Releases](https://github.com/Akunimal/Musify-for-Windows/releases) page
2. Download the latest `Musify-for-Windows-*.zip`
3. Extract the ZIP to any folder (USB drive, desktop, anywhere)
4. Run `musify.exe`

That's it. No setup, no dependencies. Works from any folder.

---

## Features

- ✅ **Portable** — runs from any folder, USB drive, or cloud-synced directory
- ✅ **Native Windows x64** — compiled for Windows, no emulation, no Android runtime
- ✅ **Online song search** with suggestions
- ✅ **Offline listening** — download songs and play without internet
- ✅ **Import & export** your data and never lose it
- ✅ **High-quality audio** streaming from YouTube Music
- ✅ **Beautiful adaptive UI** with Windows 11 Fluent icons

---

## Building from source

```bash
flutter pub get
flutter build windows --release
```

The portable executable will be at `build\windows\x64\runner\Release\musify.exe`.

---

## Credits

This is a **Windows desktop port** of the original [Musify](https://github.com/gokadzev/Musify) project by [Valeri Gokadze](https://github.com/gokadzev).  
All credit for the app's design, features, and original Android/iOS code goes to the original author.

- Original repository: [gokadzev/Musify](https://github.com/gokadzev/Musify)
- License: GPLv3 (same as original)

---

## License

This project is licensed under the GNU General Public License v3.0 — see the [LICENSE](LICENSE) file for details.
