import 'dart:async';

import 'package:media_kit/media_kit.dart' show Player;
import 'package:musify/services/settings_manager.dart' show videoModeEnabled;

class VideoPlayerBridge {
  VideoPlayerBridge._();
  static final VideoPlayerBridge instance = VideoPlayerBridge._();

  Player? _player;

  // ---------- lifecycle ----------

  void register(Player player) {
    _player?.dispose();
    _player = player;
    _setupEventStreams();
  }

  void unregister() {
    _positionSub?.cancel();
    _positionSub = null;
    _durationSub?.cancel();
    _durationSub = null;
    _completedSub?.cancel();
    _completedSub = null;
    _player = null;
  }

  bool get isRegistered => _player != null;
  bool get isActive => videoModeEnabled.value && _player != null;

  // ---------- sync state ----------

  Duration get currentPosition => _player?.state.position ?? Duration.zero;
  Duration get currentDuration => _player?.state.duration ?? Duration.zero;
  bool get isActuallyPlaying => _player?.state.playing ?? false;

  // ---------- controls ----------

  Future<void> play() async {
    final p = _player;
    if (p != null) await p.play();
  }

  Future<void> pause() async {
    final p = _player;
    if (p != null) await p.pause();
  }

  Future<void> seek(Duration position) async {
    final p = _player;
    if (p != null) await p.seek(position);
  }

  // ---------- streams ----------

  StreamSubscription? _positionSub;
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  Stream<Duration> get positionStream => _positionController.stream;

  StreamSubscription? _durationSub;
  final StreamController<Duration> _durationController =
      StreamController<Duration>.broadcast();
  Stream<Duration> get durationStream => _durationController.stream;

  StreamSubscription? _completedSub;
  final StreamController<void> _completedController =
      StreamController<void>.broadcast();
  Stream<void> get completedStream => _completedController.stream;

  void _setupEventStreams() {
    _positionSub?.cancel();
    _positionSub = _player?.stream.position.listen(
      _positionController.add,
      onError: (_) {},
    );

    _durationSub?.cancel();
    _durationSub = _player?.stream.duration.listen(
      _durationController.add,
      onError: (_) {},
    );

    _completedSub?.cancel();
    _completedSub = _player?.stream.completed.listen(
      _completedController.add,
    );
  }

  void dispose() {
    unregister();
    _positionController.close();
    _durationController.close();
    _completedController.close();
  }
}
