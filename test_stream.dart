/// Test if YouTube stream URL resolution works
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:io';

void main() async {
  final yt = YoutubeExplode();

  // Try a known working song ID
  final songId = 'dQw4w9WgXcQ';  // Rick Astley - Never Gonna Give You Up

  print('Testing stream URL resolution for: $songId');

  try {
    final manifest = await yt.videos.streams.getManifest(songId);
    final audioOnly = manifest.audioOnly;

    if (audioOnly != null && audioOnly.isNotEmpty) {
      final sorted = audioOnly.sortByBitrate();
      final best = sorted.last;
      print('SUCCESS: Found ${audioOnly.length} audio streams');
      print('Best stream: ${best.bitrate}bps - ${best.url}');
    } else {
      print('FAIL: No audio streams found');
      print('All streams: ${manifest.streams.length}');
    }
  } catch (e, stackTrace) {
    print('ERROR: $e');
    print('Stack: $stackTrace');
  }

  yt.close();
}
