# Musify for Windows — STATE.md

> **⚠️ CRITICAL: Song playback completely broken on click.**
> Click/double-click on any song does nothing — no audio, no navigation to NowPlayingPage.
> Search works, UI works, YouTube stream URL resolution works.
> This file documents every fix attempted and what remains unknown.

---

## Last updated

2026-07-24 — Session ended with playback still broken. See `AUDITORIA_PORT_WINDOWS.md` for original port plan.

---

## Symptom

- Click or double-click a song in **any** context (home, search, playlist, user songs) → nothing happens
- No audio plays, no MiniPlayer update, no navigation to NowPlayingPage
- Search works (can find songs), YouTube stream URL resolves (tested via standalone script)
- The app runs, UI is responsive, no visible errors
- No SnackBar error appears (the debug SnackBar was added but never triggered, meaning the `playSong` / `addPlaylistToQueue` methods may not even be called, or they succeed but nothing plays)

---

## Architecture — tap-to-play chain

```
User clicks song
  → SongBar._handleSongTap()          [lib/widgets/song_bar.dart:469]
    → if clearPlaylist:
        addPlaylistToQueue([song], replace: true)   [audio_service.dart]
          → _playFromQueue(0)
            → playSong(song, transitionId)
              → _resolvePlaybackSource(song)
                → _resolveOfflineAndSetPaths()
                → fetchSongStreamUrl(ytid)    [lib/services/common_services.dart:579]
                  → ytClient.videos.streams.getManifest(songId, ytClients: customClients)
                    → returns URL ✓ (verified working)
              → buildAudioSource(song, url)
              → _setAudioSourceAndPlay(song, audioSource, url)
                → audioPlayer.setAudioSource(audioSource)
                → audioPlayer.play()
    → else:
        playSong(song)  (direct, no queue management)
```

All callers pass `clearPlaylist: true` on the `SongBar` widget — so the `addPlaylistToQueue` path is always taken. This is the primary flow.

On some pages (playlist_page, user_songs_page) the `onPlay` callback is set instead, which bypasses `_handleSongTap` entirely and calls `audioHandler.playPlaylistSong()`, which in turn calls `addPlaylistToQueue(replace: true, startIndex: songIndex)` → same path.

---

## What was tried and failed

### Session 2026-07-23 (previous)
- Applied P3: queue persistence (`_saveQueueState` / `_restoreQueueState` in Hive)
- Playback broke
- `audio_service.dart` was "reverted" (possibly partially, possibly not committed) to pre-P3
- Playback still broken after revert → user said it was pre-existing

### Session 2026-07-24 (this session)
All changes in `lib/services/audio_service.dart` unless noted:

| Change | Description | Outcome |
|--------|-------------|---------|
| Fix 1 | `_isTransitioning` reset in `_playFromQueue` finally | ✅ Already existed, no change |
| Fix 2 | Guard `play()` — if queue non-empty + no audioSource, call `_playFromQueue` direct | ❌ Not the root cause |
| Fix 3 | Move `_restoreQueueState()` into `_initialize()` after session setup | ❌ Not the root cause |
| Fix 4 | Add `_isTransitioning` guard + `_AddPlaylistRequest` defer to `addPlaylistToQueue` | ❌ Not the root cause |
| Fix 5 | Remove redundant `_saveQueueState()` in `onTaskRemoved()` | ❌ Not the root cause |
| Fix 6 | Add periodic queue save timer (30s) | ❌ Not the root cause |
| **P3 strip** | **Removed ALL queue persistence:** `_saveQueueState`, `_restoreQueueState`, `_startQueueSaveTimer`, Hive save/restore methods, `dart:convert` import | **❌ Playback STILL broken** |
| Debug snackbar | Added SnackBar on failure in `_handleSongTap` | Never triggered → suggests playSong either hangs or succeeds but no audio |
| Stream URL test | Standalone `YoutubeExplode` test | ✅ URL resolves fine — 4 audio streams found |
| `flutter analyze` warnings | Fixed 100+ lint issues across codebase | Cosmetic only |

---

## Current git state

```
58e67377 (HEAD -> master) fix: remove P3 queue persistence to isolate playback regression
e9bdf925 docs: add WIP banner to README
af4e101d debug: add SnackBar feedback on playSong failure
feb5e5c9 chore: fix flutter analyze warnings
a9abe73d fix: add periodic queue state save timer
60e11e5c fix: remove redundant _saveQueueState in onTaskRemoved
33339644 fix: add _isTransitioning guard to addPlaylistToQueue
39548273 fix: move _restoreQueueState() into _initialize() after session setup
4e99aa06 fix: guard play() against destroying restored queue
93578d1b fix(ci): flutter analyze --no-fatal-warnings para Flutter 3.44
...
```

All changes are pushed to `origin/master` on `https://github.com/Akunimal/Musify-for-Windows.git`.

---

## Attempted root cause hypotheses

### Hypothesis A: `just_audio` Windows pipeline broken (STRONG)
- Stream URL resolves ✅
- `audioPlayer.setAudioSource()` might silently fail on Windows
- `audioPlayer.play()` might silently fail
- The player state might not transition to `playing`
- **Check:** Add debug logging inside `_setAudioSourceAndPlay` to see if `setAudioSource` throws/succeeds and if `play()` returns or hangs

### Hypothesis B: Tap handler not reaching play code (POSSIBLE)
- Debug SnackBar never triggered → either `playSong` returns `true` silently, or `_handleSongTap` never reaches the play path
- On Windows, `InkWell.onTap` requires specific event handling
- `HoverEffect` wraps in `MouseRegion` + `AnimatedOpacity` — might block events?
- **Check:** Add a `print` or `logger.log` at the very start of `_handleSongTap` to confirm it fires

### Hypothesis C: `just_audio_windows` plugin version incompatibility (POSSIBLE)
- `just_audio_windows: ^0.2.2` resolved to latest 0.2.x
- `just_audio: ^0.10.6` resolved to latest 0.10.x
- `audio_service: ^0.18.19`
- `audio_session: ^0.2.4`
- Maybe `just_audio_windows 0.2.3` has a bug
- **Check:** Pin to known working versions

### Hypothesis D: `ProxyManager().getClientSync()` returns broken client (WEAK)
- `ytClient = ProxyManager().getClientSync()` — returns `_sharedYt ?? _defaultYt`
- `_defaultYt = YoutubeExplode()` initialized in singleton constructor
- Standalone `YoutubeExplode()` test worked ✅
- But maybe `customClients` override causes failure
- **Check:** Test with `ytClient.videos.streams.getManifest(songId)` without customClients

### Hypothesis E: `_handleSongTap` not firing at all (POSSIBLE)
- `song_bar.dart:408`: `InkWell(onTap: _handleSongTap, ...)`
- On Windows, Flutter might not fire `onTap` for mouse clicks without explicit button handling
- **Check:** Replace `InkWell.onTap` with `GestureDetector.onTap` or add `MouseRegion` with `onTap`

---

## Key files to investigate next

| File | Why |
|------|-----|
| `lib/widgets/song_bar.dart:408` | InkWell.onTap — verify it fires on Windows |
| `lib/services/audio_service.dart:2034` | PlaySong → `_resolvePlaybackSource` — add logging |
| `lib/services/audio_service.dart:2157` | `audioPlayer.setAudioSource(audioSource)` — catch/handle errors |
| `lib/services/audio_service.dart:2184` | `audioPlayer.play()` — does it return? |
| `lib/constants/clients.dart` | `customClients` — try without |

---

## Build info

- Flutter: `/c/tools/flutter/bin/flutter` (not in PATH)
- Dart: `/c/tools/flutter/bin/cache/dart-sdk/bin/dart.exe`
- CMake: Visual Studio 17 2022, x64
- MSBuild: Visual Studio 2022 BuildTools
- No Developer Mode required — uses junctions via `C:\temp\create_junctions.bat`
- Build command: `flutter pub get` → junctions → `dart.exe assemble` → `cmake` → `msbuild` → bundle `dist/`
- Output: `C:\Extension\Musify\dist\musify.exe`

---

## Next session: priority debug steps

1. **Confirm tap handler fires** — add `logger.log('_handleSongTap called, clearPlaylist=$clearPlaylist')` at line 469 of song_bar.dart
2. **Confirm playSong is reached** — add `logger.log('playSong called for ${song['ytid']}')` at line 1978 of audio_service.dart
3. **Confirm just_audio pipeline** — add try/catch around `setAudioSource` and `play()`, log success/failure
4. **If nothing works** — try running with Flutter's `--verbose` logging, check Windows console for errors
5. **Shortcut fix** — replace `InkWell.onTap` with `GestureDetector` to rule out event-handling issues
