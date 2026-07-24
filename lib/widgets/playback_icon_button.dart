/*
 *     Copyright (C) 2026 Valeri Gokadze
 *
 *     Musify is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     Musify is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *
 *     For more information about Musify, including how to contribute,
 *     please visit: https://github.com/gokadzev/Musify
 */

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musify/extensions/l10n.dart';
import 'package:musify/main.dart';
import 'package:musify/widgets/hover_effect.dart';
import 'package:musify/utilities/app_icon.dart';

DateTime _lastPlayPauseAction = DateTime.fromMillisecondsSinceEpoch(0);

bool _canTogglePlayPause() {
  final now = DateTime.now();
  if (now.difference(_lastPlayPauseAction) < const Duration(milliseconds: 200)) {
    return false;
  }
  _lastPlayPauseAction = now;
  return true;
}

Widget buildPlaybackIconButton(
  double iconSize,
  Color iconColor,
  Color backgroundColor, {
  EdgeInsets? padding,
}) {
  return StreamBuilder<PlaybackState>(
    stream: audioHandler.playbackState.distinct((previous, current) {
      // Only rebuild if relevant state changes
      return previous.playing == current.playing &&
          previous.processingState == current.processingState;
    }),
    builder: (context, snapshot) {
      final playbackState = snapshot.data;
      final processingState = playbackState?.processingState;
      final isPlaying = playbackState?.playing ?? false;

      Widget iconWidget;
      VoidCallback? onPressed;
      String? semanticLabel;

      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        iconWidget = SizedBox(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(iconColor),
          ),
        );
        onPressed = null;
        semanticLabel = context.l10n!.loading;
      } else if (processingState == AudioProcessingState.completed) {
        iconWidget = Icon(
          AppIcon.syncIcon,
          color: iconColor,
          size: iconSize,
        );
        onPressed = () {
          if (!_canTogglePlayPause()) return;
          audioHandler.playAgain();
        };
        semanticLabel = context.l10n!.replay;
      } else {
        iconWidget = Icon(
          isPlaying
              ? AppIcon.pause
              : AppIcon.play,
          color: iconColor,
          size: iconSize,
        );
        onPressed = isPlaying
            ? () {
                if (!_canTogglePlayPause()) return;
                audioHandler.pause();
              }
            : () {
                if (!_canTogglePlayPause()) return;
                audioHandler.play();
              };
        semanticLabel = isPlaying ? context.l10n!.pause : context.l10n!.play;
      }

      return Tooltip(
        message: semanticLabel ?? context.l10n!.play,
        child: HoverEffect(
          child: RawMaterialButton(
          elevation: 0,
          onPressed: onPressed,
          fillColor: backgroundColor,
          splashColor: Colors.transparent,
          padding: padding ?? EdgeInsets.all(iconSize * 0.35),
          shape: const CircleBorder(),
          constraints: BoxConstraints.tightFor(
            width: iconSize * 2,
            height: iconSize * 2,
          ),
          materialTapTargetSize: MaterialTapTargetSize.padded,
          child: Semantics(label: semanticLabel, button: true, child: iconWidget),
        ),
      ),
      );
    },
  );
}

class PlaybackIconButton extends StatelessWidget {
  const PlaybackIconButton({
    super.key,
    required this.iconSize,
    required this.iconColor,
    required this.backgroundColor,
    this.padding,
  });

  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return buildPlaybackIconButton(
      iconSize,
      iconColor,
      backgroundColor,
      padding: padding,
    );
  }
}
