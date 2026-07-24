import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musify/main.dart';
import 'package:musify/services/settings_manager.dart';

/// Lightweight animated canvas background that responds to music playback.
///
/// - Picks a random pattern when the song changes
/// - Slow (.3×) on pause, full speed (1×) while playing
/// - Never repeats the same pattern twice
/// - Uses theme accent colors
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  static const _patterns = [
    'synapse', 'rain', 'constellations', 'sparkles',
    'embers', 'bubbles', 'squares',
  ];

  late final AnimationController _ctrl;
  String _current = '';
  String _last = '';
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 60))
      ..repeat();
    // Show a pattern immediately on startup
    _pick();
    audioHandler.playbackState.listen((s) {
      final nowPlaying = s.playing;
      if (nowPlaying != _playing) {
        if (mounted) setState(() => _playing = nowPlaying);
        // Smooth speed change: just change the duration, don't restart the controller
        _ctrl.duration = nowPlaying ? const Duration(seconds: 60) : const Duration(seconds: 120);
      }
    });
    audioHandler.mediaItem.listen((item) {
      if (item != null) _pick();
    });
  }

  void _pick() {
    final pool = [..._patterns]..remove(_last);
    _current = pool[Random().nextInt(pool.length)];
    _last = _current;
    setState(() {});
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_current.isEmpty || !animatedBgEnabled.value) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    // Use the surface color as particle color for visibility on dark themes.
    // On a "total black" theme the surface is dark, so particles use a contrasting
    // accent derived from the primary color mixed with white.
    final c = cs.primary.computeLuminance() > 0.3
        ? cs.primary
        : Color.lerp(cs.primary, Colors.white, 0.3)!;
    return IgnorePointer(
      child: SizedBox.expand(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => CustomPaint(
              painter: _makePainter(_current, _ctrl.value, c, cs),
              isComplex: true,
            ),
          ),
        ),
      ),
    );
  }

  CustomPainter _makePainter(String p, double t, Color c, ColorScheme s) {
    switch (p) {
      case 'synapse':       return _SynapsePainter(t, c);
      case 'rain':          return _RainPainter(t, c);
      case 'constellations':return _ConstPainter(t, c);
      case 'sparkles':      return _SparklesPainter(t, c);
      case 'embers':        return _EmbersPainter(t, c);
      case 'bubbles':       return _BubblesPainter(t, c);
      case 'squares':       return _SquaresPainter(t, c);
      default:              return _SynapsePainter(t, c);
    }
  }
}

// ─── Helpers ────────────────────────────────────────────────────────────────

final _rng = Random(42);
double _rnd(double a, double b) => a + _rng.nextDouble() * (b - a);
// ═══════════════════════════════════════════════════════════════════════════
// 1. SYNAPSE — grid-aligned pulses with trailing glow
// ═══════════════════════════════════════════════════════════════════════════

class _SynapsePainter extends CustomPainter {
  _SynapsePainter(this.t, this.c);
  final double t; final Color c;

  static final _ps = <_Pulse>[];

  void _maybeSpawn(double w, double h) {
    const grid = 24.0;
    if (_ps.length >= 20 || _rng.nextDouble() > 0.12) return;
    final speed = _rnd(2, 22);
    if (_rng.nextDouble() > 0.5) {
      final row = _rng.nextInt((h / grid).ceil() + 1);
      _ps.add(_Pulse(-12, row * grid, speed, 0));
    } else {
      final col = _rng.nextInt((w / grid).ceil() + 1);
      _ps.add(_Pulse(col * grid, -12, 0, speed));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _maybeSpawn(size.width, size.height);
    for (var i = _ps.length - 1; i >= 0; i--) {
      final p = _ps[i];
      p.x += p.dx; p.y += p.dy;
      if (p.x > size.width + 12 || p.y > size.height + 12) {
        _ps.removeAt(i); continue;
      }
      final tx = p.x - (p.dx > 0 ? 12 : 0);
      final ty = p.y - (p.dy > 0 ? 12 : 0);
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment(tx / size.width * 2 - 1, ty / size.height * 2 - 1),
          end: Alignment(p.x / size.width * 2 - 1, p.y / size.height * 2 - 1),
          colors: [c.withValues(alpha:0), c.withValues(alpha:0.35)],
        ).createShader(Offset.zero & size)
        ..strokeWidth = 1;
      canvas.drawLine(Offset(tx, ty), Offset(p.x, p.y), paint);
    }
  }

  @override bool shouldRepaint(_SynapsePainter o) => o.t != t;
}

class _Pulse { _Pulse(this.x, this.y, this.dx, this.dy); double x, y, dx, dy; }

// ═══════════════════════════════════════════════════════════════════════════
// 2. RAIN — falling rain drops with variable speed
// ═══════════════════════════════════════════════════════════════════════════

class _RainPainter extends CustomPainter {
  _RainPainter(this.t, this.c);
  final double t; final Color c;

  static final _drops = <_Drop>[];
  void _spawn(double w, double h) {
    if (_drops.length >= 130 || _rng.nextDouble() > 0.6) return;
    final len = _rnd(20, 60);
    _drops.add(_Drop(_rnd(0, w), -len, len, _rnd(4, 12), _rnd(0.32, 0.6)));
  }

  @override
  void paint(Canvas canvas, Size size) {
    _spawn(size.width, size.height);
    for (var i = _drops.length - 1; i >= 0; i--) {
      final d = _drops[i];
      d.y += d.speed;
      if (d.y > size.height + d.len) { _drops.removeAt(i); continue; }
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment(d.x / size.width * 2 - 1, (d.y - d.len) / size.height * 2 - 1),
          end: Alignment(d.x / size.width * 2 - 1, d.y / size.height * 2 - 1),
          colors: [c.withValues(alpha:0), c.withValues(alpha:d.alpha)],
        ).createShader(Offset.zero & size)
        ..strokeWidth = 1.3;
      canvas.drawLine(Offset(d.x, d.y - d.len), Offset(d.x, d.y), paint);
    }
  }

  @override bool shouldRepaint(_RainPainter o) => o.t != t;
}

class _Drop { _Drop(this.x, this.y, this.len, this.speed, this.alpha); double x, y, len, speed, alpha; }

// ═══════════════════════════════════════════════════════════════════════════
// 3. CONSTELLATIONS — static dots with slowly connecting lines
// ═══════════════════════════════════════════════════════════════════════════

class _ConstPainter extends CustomPainter {
  _ConstPainter(this.t, this.c);
  final double t; final Color c;

  static List<_Star>? _stars;
  static double _lastW = 0, _lastH = 0;

  void _init(double w, double h) {
    _stars = List.generate(50, (_) => _Star(_rnd(0, w), _rnd(0, h), _rnd(1, 3)));
    _lastW = w; _lastH = h;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_stars == null || size.width != _lastW || size.height != _lastH) {
      _init(size.width, size.height);
    }
    final stars = _stars!;
    const connectDist = 120.0;
    final fade = (sin(t * pi * 2) + 1) / 2;

    // Lines
    final linePaint = Paint()..color = c.withValues(alpha:0.08 * fade)..strokeWidth = 0.5;
    for (var i = 0; i < stars.length; i++) {
      for (var j = i + 1; j < stars.length; j++) {
        final dx = stars[i].x - stars[j].x, dy = stars[i].y - stars[j].y;
        if (dx * dx + dy * dy < connectDist * connectDist) {
          canvas.drawLine(Offset(stars[i].x, stars[i].y), Offset(stars[j].x, stars[j].y), linePaint);
        }
      }
    }

    // Dots
    final dotPaint = Paint()..color = c.withValues(alpha:0.5 * fade);
    for (final s in stars) {
      canvas.drawCircle(Offset(s.x, s.y), s.r, dotPaint);
    }
  }

  @override bool shouldRepaint(_ConstPainter o) => o.t != t;
}

class _Star { _Star(this.x, this.y, this.r); double x, y, r; }

// ═══════════════════════════════════════════════════════════════════════════
// 4. SPARKLES — twinkling 4-point stars
// ═══════════════════════════════════════════════════════════════════════════

class _SparklesPainter extends CustomPainter {
  _SparklesPainter(this.t, this.c);
  final double t; final Color c;

  static List<_Spark>? _sparks;
  static double _sw = 0, _sh = 0;

  void _init(double w, double h) {
    _sw = w; _sh = h;
    _sparks = List.generate(35, (_) => _make(w, h));
  }

  static _Spark _make(double w, double h) => _Spark(_rnd(0, w), _rnd(0, h), _rnd(2, 7), _rnd(0, pi * 2), _rnd(0.015, 0.045), _rnd(0.5, 1));

  @override
  void paint(Canvas canvas, Size size) {
    if (_sparks == null || size.width != _sw || size.height != _sh) {
      _init(size.width, size.height);
    }
    final sparks = _sparks!;

    for (var i = 0; i < sparks.length; i++) {
      final s = sparks[i];
      s.phase += s.speed;
      final twinkle = sin(s.phase);
      final alpha = max(0, twinkle) * 0.25 * s.life;
      if (alpha < 0.01) continue;
      final scale = 0.5 + max(0, twinkle) * 0.5;
      final r = s.size * scale;
      canvas.save();
      canvas.translate(s.x, s.y);
      final p = Paint()..color = c.withValues(alpha:alpha)..style = PaintingStyle.fill;
      final path = Path()
        ..moveTo(0, -r)
        ..quadraticBezierTo(r * 0.15, -r * 0.15, r, 0)
        ..quadraticBezierTo(r * 0.15, r * 0.15, 0, r)
        ..quadraticBezierTo(-r * 0.15, r * 0.15, -r, 0)
        ..quadraticBezierTo(-r * 0.15, -r * 0.15, 0, -r)
        ..close();
      canvas.drawPath(path, p);
      canvas.restore();
      if (s.phase > pi * 6) {
        _sparks![i] = _make(_sw, _sh);
      }
    }
  }

  @override bool shouldRepaint(_SparklesPainter o) => o.t != t;
}

class _Spark { _Spark(this.x, this.y, this.size, this.phase, this.speed, this.life); double x, y, size, phase, speed, life; }

// ═══════════════════════════════════════════════════════════════════════════
// 5. EMBERS — warm particles rising with glow
// ═══════════════════════════════════════════════════════════════════════════

class _EmbersPainter extends CustomPainter {
  _EmbersPainter(this.t, this.c);
  final double t; final Color c;

  static final _embers = <_Ember>[];

  void _spawn(double w, double h) {
    if (_embers.length >= 30 || _rng.nextDouble() > 0.15) return;
    _embers.add(_Ember(_rnd(0, w), h + 5, _rnd(2, 5), _rnd(-0.3, 0.3), _rnd(-1.5, -0.5), _rnd(0.3, 0.8)));
  }

  @override
  void paint(Canvas canvas, Size size) {
    _spawn(size.width, size.height);
    for (var i = _embers.length - 1; i >= 0; i--) {
      final e = _embers[i];
      e.x += e.dx; e.y += e.dy;
      e.dx += _rng.nextDouble() * 0.2 - 0.1;
      e.dx = e.dx.clamp(-1, 1);
      if (e.y < -10 || e.x < -10 || e.x > size.width + 10) { _embers.removeAt(i); continue; }
      final glow = Paint()..color = c.withValues(alpha:0.15 * e.alpha)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(e.x, e.y), e.r * 1.5, glow);
      final core = Paint()..color = c.withValues(alpha:0.6 * e.alpha);
      canvas.drawCircle(Offset(e.x, e.y), e.r * 0.5, core);
    }
  }

  @override bool shouldRepaint(_EmbersPainter o) => o.t != t;
}

class _Ember { _Ember(this.x, this.y, this.r, this.dx, this.dy, this.alpha); double x, y, r, dx, dy, alpha; }

// ═══════════════════════════════════════════════════════════════════════════
// 6. BUBBLES — rising transparent circles
// ═══════════════════════════════════════════════════════════════════════════

class _BubblesPainter extends CustomPainter {
  _BubblesPainter(this.t, this.c);
  final double t; final Color c;

  static final _bs = <_Bubble>[];

  void _spawn(double w, double h) {
    if (_bs.length >= 20 || _rng.nextDouble() > 0.1) return;
    _bs.add(_Bubble(_rnd(0, w), h + 10, _rnd(3, 15), _rnd(-0.2, 0.2), _rnd(-1.5, -0.3), _rnd(0.05, 0.15)));
  }

  @override
  void paint(Canvas canvas, Size size) {
    _spawn(size.width, size.height);
    for (var i = _bs.length - 1; i >= 0; i--) {
      final b = _bs[i];
      b.x += b.dx; b.y += b.dy;
      b.dx += _rng.nextDouble() * 0.1 - 0.05;
      b.dx = b.dx.clamp(-0.5, 0.5);
      if (b.y < -20) { _bs.removeAt(i); continue; }
      canvas.drawCircle(Offset(b.x, b.y), b.r, Paint()..color = c.withValues(alpha:b.alpha)..style = PaintingStyle.stroke..strokeWidth = 1);
    }
  }

  @override bool shouldRepaint(_BubblesPainter o) => o.t != t;
}

class _Bubble { _Bubble(this.x, this.y, this.r, this.dx, this.dy, this.alpha); double x, y, r, dx, dy, alpha; }

// ═══════════════════════════════════════════════════════════════════════════
// 7. SQUARES — floating/fading squares
// ═══════════════════════════════════════════════════════════════════════════

class _SquaresPainter extends CustomPainter {
  _SquaresPainter(this.t, this.c);
  final double t; final Color c;

  static final _sqs = <_Square>[];

  void _spawn(double w, double h) {
    if (_sqs.length >= 25 || _rng.nextDouble() > 0.12) return;
    _sqs.add(_Square(_rnd(0, w), _rnd(-20, h), _rnd(4, 18), _rnd(-0.3, 0.3), _rnd(-0.3, -0.05), _rnd(0, pi * 2), _rnd(0.02, 0.06), _rnd(0.05, 0.15)));
  }

  @override
  void paint(Canvas canvas, Size size) {
    _spawn(size.width, size.height);
    for (var i = _sqs.length - 1; i >= 0; i--) {
      final s = _sqs[i];
      s.x += s.dx; s.y += s.dy;
      s.rot += s.rotSpeed;
      if (s.y > size.height + 20 || s.x < -20 || s.x > size.width + 20) { _sqs.removeAt(i); continue; }
      canvas.save();
      canvas.translate(s.x, s.y);
      canvas.rotate(s.rot);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: s.size, height: s.size),
          Paint()..color = c.withValues(alpha:s.alpha)..style = PaintingStyle.stroke..strokeWidth = 1);
      canvas.restore();
    }
  }

  @override bool shouldRepaint(_SquaresPainter o) => o.t != t;
}

class _Square { _Square(this.x, this.y, this.size, this.dx, this.dy, this.rot, this.rotSpeed, this.alpha); double x, y, size, dx, dy, rot, rotSpeed, alpha; }
