import 'package:flutter/material.dart';
import 'package:musify/utilities/app_icon.dart';
import 'package:musify/services/proxy_manager.dart';

/// Placeholder for video mode — replaces album art when toggled on.
/// Actual video playback requires media_kit (not bundled in this build).
/// Kept as a structural placeholder so the toggle UI remains functional.
class YoutubeVideoPlayer extends StatelessWidget {
  const YoutubeVideoPlayer({
    super.key,
    required this.ytid,
    this.playing = true,
  });

  final String ytid;
  final bool playing;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcon.video, size: 64, color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
          const SizedBox(height: 8),
          Text(
            'Video mode ready',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Install media_kit to enable playback',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
