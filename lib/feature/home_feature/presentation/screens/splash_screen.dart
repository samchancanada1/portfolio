import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.duration = const Duration(milliseconds: 1900),
  });

  final Duration duration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  bool _showHome = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.72, curve: Curves.easeOutCubic),
    );
    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.42, curve: Curves.easeOut),
    );
    _showHomeAfterSplash();
  }

  Future<void> _showHomeAfterSplash() async {
    await Future<void>.delayed(widget.duration);
    if (!mounted) {
      return;
    }
    setState(() {
      _showHome = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (_showHome) {
      return const HomeScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (final context, final child) {
          return CustomPaint(
            painter: _SplashHudPainter(progress: _controller.value),
            child: Center(
              child: Opacity(
                opacity: _logoOpacity.value,
                child: Transform.scale(
                  scale: 0.84 + (_logoScale.value * 0.16),
                  child: Image.asset(
                    'assets/brand/hc-logo-1024.png',
                    width: 188,
                    height: 188,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SplashHudPainter extends CustomPainter {
  const _SplashHudPainter({required this.progress});

  final double progress;

  @override
  void paint(final Canvas canvas, final Size size) {
    final Offset center = size.center(Offset.zero);
    final double shortestSide = math.min(size.width, size.height);
    final double radius = shortestSide * 0.24;
    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color =
          const Color(0xff6FFFE9).withValues(alpha: 0.18 + progress * 0.2);
    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square
      ..color =
          const Color(0xff00E7C8).withValues(alpha: 0.18 + progress * 0.5);
    final Paint nodePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.secondColor.withValues(alpha: progress);

    canvas.drawCircle(center, radius * (0.76 + progress * 0.16), glowPaint);
    canvas.drawCircle(center, radius * (1.05 + progress * 0.08), glowPaint);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * math.pi * 1.5);
    for (int index = 0; index < 8; index++) {
      canvas.rotate(math.pi / 4);
      canvas.drawLine(
        Offset(radius * 1.18, 0),
        Offset(radius * 1.62, 0),
        linePaint,
      );
      canvas.drawCircle(Offset(radius * 1.67, 0), 4 + progress * 5, nodePaint);
    }
    canvas.restore();

    final Paint scanPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          const Color(0xff27F4DC).withValues(alpha: 0.0),
          const Color(0xff27F4DC).withValues(alpha: 0.42),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final double y = size.height * (0.2 + progress * 0.58);
    canvas.drawRect(Rect.fromLTWH(0, y, size.width, 3), scanPaint);

    final Paint cornerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.square
      ..color = const Color(0xff6FFFE9).withValues(alpha: 0.32);
    final double inset = shortestSide * 0.12;
    final double corner = shortestSide * 0.11;
    canvas.drawLine(
        Offset(inset, inset), Offset(inset + corner, inset), cornerPaint);
    canvas.drawLine(
        Offset(inset, inset), Offset(inset, inset + corner), cornerPaint);
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(size.width - inset - corner, inset),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(size.width - inset, inset + corner),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(inset, size.height - inset),
      Offset(inset + corner, size.height - inset),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(inset, size.height - inset),
      Offset(inset, size.height - inset - corner),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width - inset, size.height - inset),
      Offset(size.width - inset - corner, size.height - inset),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width - inset, size.height - inset),
      Offset(size.width - inset, size.height - inset - corner),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(final _SplashHudPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
