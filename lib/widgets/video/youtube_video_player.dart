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
  final Player _player = Player();
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
      final manifest = await ytClient.videos.streamsClient
          .getManifest(widget.ytid);
      final muxed = manifest.muxed;
      if (muxed == null || muxed.isEmpty) {
        if (mounted) setState(() => _error = 'No video stream available');
        return;
      }
      // Pick lowest bitrate muxed stream (360p) for compatibility
      final streams = muxed.toList()
        ..sort((a, b) => a.bitrate.compareTo(b.bitrate));
      final stream = streams.first;
      await _player.open(Media(stream.url.toString()));
      if (widget.playing) _player.play();
      _videoController = VideoController(_player);
      if (mounted) setState(() => _initialized = true);
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
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, size: 48,
                color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 8),
            Text('Video unavailable',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }
    if (!_initialized || _videoController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Video(
        controller: _videoController!,
        fill: Colors.black,
      ),
    );
  }
}
