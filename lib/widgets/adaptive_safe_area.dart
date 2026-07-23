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

import 'dart:io';

import 'package:flutter/material.dart';

/// SafeArea wrapper that only applies system padding on mobile (Android/iOS).
/// On desktop (Windows/Linux/macOS) system insets are zero, so SafeArea is
/// redundant.
class AdaptiveSafeArea extends StatelessWidget {
  const AdaptiveSafeArea({
    super.key,
    required this.child,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  final Widget child;
  final bool? top;
  final bool? bottom;
  final bool? left;
  final bool? right;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return SafeArea(
        top: top ?? true,
        bottom: bottom ?? true,
        left: left ?? true,
        right: right ?? true,
        child: child,
      );
    }
    return child;
  }
}

/// Sliver version of [AdaptiveSafeArea].
class AdaptiveSliverSafeArea extends StatelessWidget {
  const AdaptiveSliverSafeArea({
    super.key,
    required this.sliver,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  final Widget sliver;
  final bool? top;
  final bool? bottom;
  final bool? left;
  final bool? right;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return SliverSafeArea(
        top: top ?? true,
        bottom: bottom ?? true,
        left: left ?? true,
        right: right ?? true,
        sliver: sliver,
      );
    }
    return sliver;
  }
}
