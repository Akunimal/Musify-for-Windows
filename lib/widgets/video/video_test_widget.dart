import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// Test widget that plays a known-good public domain video URL to verify
/// media_kit video rendering works on this platform.
class VideoTestWidget extends StatefulWidget {
  final String url;
  const VideoTestWidget({super.key, required this.url});

  @override
  State<VideoTestWidget> createState() => _VideoTestWidgetState();
}

class _VideoTestWidgetState extends State<VideoTestWidget> {
  final Player _player = Player(
    configuration: const PlayerConfiguration(osc: false, title: 'Musify Video Test'),
  );
  VideoController? _controller;
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.open(Media(widget.url));
      _player.stream.error.listen((e) {
        if (mounted) setState(() => _error = e);
      });
      _player.stream.playing.listen((_) {
        // Video started playing — rendering works!
        if (mounted && !_ready) setState(() => _ready = true);
      });
      _controller = VideoController(_player);
      if (mounted) setState(() => _ready = true);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
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
        child: Text('Error: $_error',
          style: TextStyle(color: Theme.of(context).colorScheme.error)),
      );
    }
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox.expand(
        child: Video(
          controller: _controller!,
          fill: Colors.black,
          controls: (s) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
