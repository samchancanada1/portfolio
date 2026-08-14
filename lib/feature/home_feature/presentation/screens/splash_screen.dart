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
          final double progress = _controller.value;
          return CustomPaint(
            painter: _SplashHudPainter(progress: progress),
            child: Center(
              child: _AnimatedSplashLogo(
                opacity: _logoOpacity.value,
                progress: progress,
                scale: 0.78 + (_logoScale.value * 0.22),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedSplashLogo extends StatelessWidget {
  const _AnimatedSplashLogo({
    required this.opacity,
    required this.progress,
    required this.scale,
  });

  final double opacity;
  final double progress;
  final double scale;

  @override
  Widget build(final BuildContext context) {
    final double size = MediaQuery.sizeOf(context).width < 520 ? 210 : 252;
    final double settledProgress = Curves.easeOutCubic.transform(progress);
    final double jitter = math.sin(progress * math.pi * 22) * (1 - progress);

    return SizedBox.square(
      dimension: size * 1.54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: progress * math.pi * 1.85,
            child: Container(
              width: size * 1.36,
              height: size * 1.36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xff49F4DD).withValues(alpha: 0.48),
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff00E7C8).withValues(alpha: 0.24),
                    blurRadius: 30,
                    spreadRadius: 3,
                  ),
                ],
              ),
            ),
          ),
          Transform.rotate(
            angle: -progress * math.pi * 1.2,
            child: CustomPaint(
              size: Size.square(size * 1.22),
              painter: _LogoScannerPainter(progress: progress),
            ),
          ),
          Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(jitter * 5, -12 + (12 * settledProgress)),
              child: Transform.scale(
                scale: scale,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff071315).withValues(alpha: 0.62),
                        blurRadius: 34,
                        offset: const Offset(0, 20),
                      ),
                      BoxShadow(
                        color: const Color(0xff6FFFE9).withValues(alpha: 0.28),
                        blurRadius: 48,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/brand/tung-dev-logo.png',
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _LogoScanlinePainter(progress: progress),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoScannerPainter extends CustomPainter {
  const _LogoScannerPainter({required this.progress});

  final double progress;

  @override
  void paint(final Canvas canvas, final Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.shortestSide / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    final Paint arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xff00E7C8).withValues(alpha: 0.72);
    final Paint softArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.34);

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * (0.68 + progress * 0.24),
      false,
      arcPaint,
    );
    canvas.drawArc(
      rect.deflate(radius * 0.11),
      math.pi * 0.58,
      math.pi * 0.34,
      false,
      softArcPaint,
    );
    canvas.drawArc(
      rect.inflate(radius * 0.11),
      math.pi * 1.22,
      math.pi * 0.28,
      false,
      softArcPaint,
    );
  }

  @override
  bool shouldRepaint(final _LogoScannerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _LogoScanlinePainter extends CustomPainter {
  const _LogoScanlinePainter({required this.progress});

  final double progress;

  @override
  void paint(final Canvas canvas, final Size size) {
    final double sweepY = size.height * (0.18 + progress * 0.62);
    final Paint beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          const Color(0xff6FFFE9).withValues(alpha: 0.18),
          Colors.white.withValues(alpha: 0.42),
          const Color(0xff6FFFE9).withValues(alpha: 0.18),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, sweepY - 10, size.width, 20));

    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.14, sweepY - 2, size.width * 0.72, 4),
      beamPaint,
    );
  }

  @override
  bool shouldRepaint(final _LogoScanlinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _SplashHudPainter extends CustomPainter {
  const _SplashHudPainter({required this.progress});

  final double progress;

  @override
  void paint(final Canvas canvas, final Size size) {
    final Offset center = size.center(Offset.zero);
    final double shortestSide = math.min(size.width, size.height);
    final double radius = shortestSide * 0.27;
    final Paint gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xffF4FFFC).withValues(alpha: 0.035);
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

    for (double x = 0; x < size.width; x += 42) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 42) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    canvas.drawCircle(center, radius * (0.76 + progress * 0.16), glowPaint);
    canvas.drawCircle(center, radius * (1.05 + progress * 0.08), glowPaint);
    canvas.drawCircle(center, radius * (1.28 + progress * 0.04), glowPaint);

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

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-progress * math.pi * 0.85);
    final Paint tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.square
      ..color = Colors.white.withValues(alpha: 0.2);
    for (int index = 0; index < 40; index++) {
      canvas.rotate(math.pi / 20);
      final double tickLength = index % 5 == 0 ? 14 : 7;
      canvas.drawLine(
        Offset(radius * 1.34, 0),
        Offset(radius * 1.34 + tickLength, 0),
        tickPaint,
      );
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
