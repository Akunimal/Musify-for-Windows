/* license header — same as original */
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:go_router/go_router.dart';
import 'package:musify/extensions/l10n.dart';
import 'package:musify/main.dart';
import 'package:musify/services/data_manager.dart';
import 'package:musify/services/settings_manager.dart';
import 'package:musify/utilities/app_icon.dart';
import 'package:musify/widgets/now_playing/bottom_actions_row.dart';
import 'package:musify/widgets/now_playing/now_playing_artwork.dart';
import 'package:musify/widgets/now_playing/now_playing_controls.dart';
import 'package:musify/widgets/queue_list_view.dart';
import 'package:musify/widgets/video/youtube_video_player.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  final _lyricsController = FlipCardController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isLargeScreen = size.width > 800 && size.height > 600;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = size.width;
    final baseIconSize = screenWidth < 360
        ? 36.0
        : screenWidth < 400
        ? 40.0
        : 44.0;
    final miniIconSize = screenWidth < 360 ? 18.0 : 22.0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: StreamBuilder<MediaItem?>(
          stream: audioHandler.mediaItem,
          builder: (ctx, snapshot) {
            if (snapshot.data == null || !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final metadata = snapshot.data!;
            return Column(
              children: [
                _buildAppBar(ctx, colorScheme, metadata),
                Expanded(
                  child: isLargeScreen
                      ? _DesktopLayout(
                          metadata: metadata,
                          size: size,
                          adjustedIconSize: baseIconSize,
                          adjustedMiniIconSize: miniIconSize,
                          lyricsController: _lyricsController,
                        )
                      : _MobileLayout(
                          metadata: metadata,
                          size: size,
                          adjustedIconSize: baseIconSize,
                          adjustedMiniIconSize: miniIconSize,
                          isLargeScreen: isLargeScreen,
                          lyricsController: _lyricsController,
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme colorScheme, MediaItem metadata) {
    final isVideo = videoModeEnabled.value;
    final ytid = metadata.extras?['ytid']?.toString();
    final hasVideo = ytid != null && ytid.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed: () => context.pop(),
          ),
          const Spacer(),
          if (hasVideo)
            IconButton(
              icon: Icon(isVideo ? AppIcon.play : AppIcon.video,
                  color: colorScheme.primary),
              tooltip: isVideo ? 'Switch to Audio' : 'Switch to Video',
              onPressed: () {
                final newMode = !isVideo;
                videoModeEnabled.value = newMode;
                if (newMode) audioHandler.stop();
                addOrUpdateData<bool>('settings', 'videoModeEnabled', newMode);
              },
            ),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.metadata,
    required this.size,
    required this.adjustedIconSize,
    required this.adjustedMiniIconSize,
    required this.lyricsController,
  });

  final MediaItem metadata;
  final Size size;
  final double adjustedIconSize;
  final double adjustedMiniIconSize;
  final FlipCardController lyricsController;

  @override
  Widget build(BuildContext context) {
    final ytid = metadata.extras?['ytid']?.toString();
    final hasVideo = videoModeEnabled.value && ytid != null && ytid.isNotEmpty;

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: hasVideo
                        ? YoutubeVideoPlayer(ytid: ytid!, key: ValueKey(ytid), playing: true)
                        : NowPlayingArtwork(
                            size: size,
                            metadata: metadata,
                            lyricsController: lyricsController,
                          ),
                  ),
                ),
                if (!(metadata.extras?['isLive'] ?? false))
                  Expanded(
                    flex: 4,
                    child: NowPlayingControls(
                      size: size,
                      audioId: metadata.extras?['ytid'],
                      adjustedIconSize: adjustedIconSize,
                      adjustedMiniIconSize: adjustedMiniIconSize,
                      metadata: metadata,
                    ),
                  ),
                BottomActionsRow(
                  metadata: metadata,
                  iconSize: adjustedMiniIconSize,
                  isLargeScreen: true,
                  lyricsController: lyricsController,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        const Expanded(child: QueueWidget()),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.metadata,
    required this.size,
    required this.adjustedIconSize,
    required this.adjustedMiniIconSize,
    required this.isLargeScreen,
    required this.lyricsController,
  });

  final MediaItem metadata;
  final Size size;
  final double adjustedIconSize;
  final double adjustedMiniIconSize;
  final bool isLargeScreen;
  final FlipCardController lyricsController;

  @override
  Widget build(BuildContext context) {
    final isLandscape = size.width > size.height;

    if (isLandscape) {
      return _buildLandscapeLayout(context);
    }
    return _buildPortraitLayout(context);
  }

  Widget _buildPortraitLayout(BuildContext context) {
    final isLive = metadata.extras?['isLive'] ?? false;
    final ytid = metadata.extras?['ytid']?.toString();
    final hasVideo = videoModeEnabled.value && ytid != null && ytid.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            flex: 5,
            child: Center(
              child: hasVideo
                  ? YoutubeVideoPlayer(ytid: ytid!, playing: true)
                  : NowPlayingArtwork(
                      size: size,
                      metadata: metadata,
                      lyricsController: lyricsController,
                    ),
            ),
          ),
          if (!isLive)
            Expanded(
              flex: 4,
              child: NowPlayingControls(
                size: size,
                audioId: metadata.extras?['ytid'],
                adjustedIconSize: adjustedIconSize,
                adjustedMiniIconSize: adjustedMiniIconSize,
                metadata: metadata,
              ),
            ),
          BottomActionsRow(
            metadata: metadata,
            iconSize: adjustedMiniIconSize,
            isLargeScreen: isLargeScreen,
            lyricsController: lyricsController,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    final isLive = metadata.extras?['isLive'] ?? false;
    final ytid = metadata.extras?['ytid']?.toString();
    final hasVideo = videoModeEnabled.value && ytid != null && ytid.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: hasVideo
                  ? YoutubeVideoPlayer(ytid: ytid!, playing: true)
                  : NowPlayingArtwork(
                      size: size,
                      metadata: metadata,
                      lyricsController: lyricsController,
                    ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isLive)
                  Expanded(
                    child: NowPlayingControls(
                      size: size,
                      audioId: metadata.extras?['ytid'],
                      adjustedIconSize: adjustedIconSize,
                      adjustedMiniIconSize: adjustedMiniIconSize,
                      metadata: metadata,
                    ),
                  ),
                BottomActionsRow(
                  metadata: metadata,
                  iconSize: adjustedMiniIconSize,
                  isLargeScreen: isLargeScreen,
                  lyricsController: lyricsController,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
