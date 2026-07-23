import 'package:flutter/material.dart';

/// IconData constants using fontFamily 'Segoe UI' (system font on Windows).
/// Bypasses MaterialIcons font entirely. Works on all Windows versions.
///
/// Use as drop-in replacement for `Icons.xxx`:
///   `Icon(AppIcon.xxx)` or `icon: AppIcon.xxx`
class AppIcon {
  AppIcon._();

  // Navigation
  static const IconData home = IconData(0x2302, fontFamily: 'Segoe UI');
  static const IconData search = IconData(0x26B2, fontFamily: 'Segoe UI');
  static const IconData library = IconData(0x2630, fontFamily: 'Segoe UI');
  static const IconData settings = IconData(0x2699, fontFamily: 'Segoe UI');

  // Playback
  static const IconData play = IconData(0x25B6, fontFamily: 'Segoe UI');
  static const IconData pause = IconData(0x2016, fontFamily: 'Segoe UI');
  static const IconData previous = IconData(0x23EE, fontFamily: 'Segoe UI');
  static const IconData next = IconData(0x23ED, fontFamily: 'Segoe UI');
  static const IconData shuffle = IconData(0x21C7, fontFamily: 'Segoe UI');
  static const IconData repeatAll = IconData(0x21BB, fontFamily: 'Segoe UI');
  static const IconData stop = IconData(0x25A0, fontFamily: 'Segoe UI');

  // Actions
  static const IconData heart = IconData(0x2665, fontFamily: 'Segoe UI');
  static const IconData heartFilled = IconData(0x2764, fontFamily: 'Segoe UI');
  static const IconData heartOff = IconData(0x2661, fontFamily: 'Segoe UI');
  static const IconData add = IconData(0x2795, fontFamily: 'Segoe UI');
  static const IconData delete = IconData(0x2717, fontFamily: 'Segoe UI');
  static const IconData edit = IconData(0x270E, fontFamily: 'Segoe UI');
  static const IconData close = IconData(0x2715, fontFamily: 'Segoe UI');
  static const IconData download = IconData(0x21E7, fontFamily: 'Segoe UI');
  static const IconData share = IconData(0x21AA, fontFamily: 'Segoe UI');
  static const IconData save = IconData(0x2714, fontFamily: 'Segoe UI');
  static const IconData check = IconData(0x2713, fontFamily: 'Segoe UI');

  // Media
  static const IconData musicNote = IconData(0x266A, fontFamily: 'Segoe UI');
  static const IconData musicNotes = IconData(0x266B, fontFamily: 'Segoe UI');
  static const IconData album = IconData(0x266C, fontFamily: 'Segoe UI');
  static const IconData queue = IconData(0x2630, fontFamily: 'Segoe UI');
  static const IconData volume = IconData(0x266C, fontFamily: 'Segoe UI');
  static const IconData mic = IconData(0x266C, fontFamily: 'Segoe UI');

  // UI
  static const IconData clock = IconData(0x23F1, fontFamily: 'Segoe UI');
  static const IconData history = IconData(0x29D6, fontFamily: 'Segoe UI');
  static const IconData folder = IconData(0x25A1, fontFamily: 'Segoe UI');
  static const IconData folderOpen = IconData(0x25A3, fontFamily: 'Segoe UI');
  static const IconData pin = IconData(0x25C9, fontFamily: 'Segoe UI');
  static const IconData person = IconData(0x263A, fontFamily: 'Segoe UI');
  static const IconData people = IconData(0x263B, fontFamily: 'Segoe UI');
  static const IconData globe = IconData(0x25CE, fontFamily: 'Segoe UI');
  static const IconData link = IconData(0x29C9, fontFamily: 'Segoe UI');
  static const IconData image = IconData(0x25A8, fontFamily: 'Segoe UI');
  static const IconData syncIcon = IconData(0x21BB, fontFamily: 'Segoe UI');
  static const IconData cloud = IconData(0x2601, fontFamily: 'Segoe UI');
  static const IconData cloudOff = IconData(0x2602, fontFamily: 'Segoe UI');
  static const IconData sun = IconData(0x2600, fontFamily: 'Segoe UI');
  static const IconData moon = IconData(0x263E, fontFamily: 'Segoe UI');
  static const IconData more = IconData(0x22EF, fontFamily: 'Segoe UI');
  static const IconData list = IconData(0x2261, fontFamily: 'Segoe UI');
  static const IconData info = IconData(0x24D8, fontFamily: 'Segoe UI');
  static const IconData warning = IconData(0x26A0, fontFamily: 'Segoe UI');
  static const IconData help = IconData(0x2753, fontFamily: 'Segoe UI');
  static const IconData menu = IconData(0x2630, fontFamily: 'Segoe UI');

  // App-specific
  static const IconData likedSongs = IconData(0x2665, fontFamily: 'Segoe UI');
  static const IconData equalizer = IconData(0x25A8, fontFamily: 'Segoe UI');
  static const IconData trending = IconData(0x2197, fontFamily: 'Segoe UI');
  static const IconData shield = IconData(0x26E8, fontFamily: 'Segoe UI');
  static const IconData sparkle = IconData(0x2726, fontFamily: 'Segoe UI');
  static const IconData code = IconData(0x2328, fontFamily: 'Segoe UI');
  static const IconData language = IconData(0x25CB, fontFamily: 'Segoe UI');
  static const IconData color = IconData(0x25EF, fontFamily: 'Segoe UI');
  static const IconData forward = IconData(0x25B6, fontFamily: 'Segoe UI');
  static const IconData backward = IconData(0x25C0, fontFamily: 'Segoe UI');
  static const IconData addCircle = IconData(0x2295, fontFamily: 'Segoe UI');
  static const IconData emptyState = IconData(0x25A1, fontFamily: 'Segoe UI');
  static const IconData megaphone = IconData(0x1F4E2, fontFamily: 'Segoe UI');
}
