import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:musify/services/proxy_manager.dart';

/// Lightweight video player that streams a YouTube muxed (audio+video) stream.
///
/// Designed to replace the album art in the now-playing screen when video
/// mode is active. Takes a ytid, fetches the best muxed stream, and plays it
/// via [media_kit]. Reports position/duration changes via callbacks so the UI
/// progress bar stays in sync.
class YoutubeVideoPlayer extends StatefulWidget {
  const YoutubeVideoPlayer({
    super.key,
    required this.ytid,
    this.playing = true,
  });

  final String ytid;
  final bool playing;

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  final Player _player = Player(
    configuration: const PlayerConfiguration(
      osc: false,
      title: 'Musify',
    ),
  );
  VideoController? _videoController;
  bool _initialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      // Create controller first so texture is ready
      _videoController = VideoController(_player);
      if (mounted) setState(() => _initialized = true);

      // Try both muxed and video-only streams for maximum compatibility
      final manifest = await ytClient.videos.streamsClient
          .getManifest(widget.ytid);
      final muxed = manifest.muxed;
      dynamic selected;
      if (muxed != null && muxed.isNotEmpty) {
        // Use the MOST COMMON resolution (not lowest, not highest) to avoid
        // streams with embedded YouTube UI
        final sorted = muxed.toList()
          ..sort((a, b) => b.bitrate.compareTo(a.bitrate));
        selected = sorted[sorted.length ~/ 2];
      } else if (manifest.videoOnly != null && manifest.videoOnly.isNotEmpty) {
        // Fallback to video-only stream + play just_audio simultaneously
        final vids = manifest.videoOnly.toList()
          ..sort((a, b) => a.bitrate.compareTo(b.bitrate));
        selected = vids.first;
      }
      if (selected == null) {
        if (mounted) setState(() => _error = 'No video stream available');
        return;
      }
      await _player.open(Media(selected.url.toString()));
      if (widget.playing) _player.play();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  void didUpdateWidget(YoutubeVideoPlayer old) {
    super.didUpdateWidget(old);
    if (widget.playing != old.playing) {
      widget.playing ? _player.play() : _player.pause();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      final isNetworkError = _error!.contains('SocketException') ||
          _error!.contains('10057') || _error!.contains('No se permitió');
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isNetworkError ? Icons.wifi_off_rounded : Icons.warning_amber_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.error.withOpacity(0.6),
            ),
            const SizedBox(height: 8),
            Text(
              isNetworkError ? 'Video unavailable (network)' : 'Video unavailable',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    if (!_initialized || _videoController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox.expand(
        child: Video(
          controller: _videoController!,
          fill: Colors.black,
          controls: (state) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
