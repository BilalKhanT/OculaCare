import 'package:flutter/material.dart';
import 'dart:math';

class DotLoader extends StatefulWidget {
  final Color loaderColor;

  const DotLoader({super.key, required this.loaderColor});

  @override
  CustomLoaderState createState() => CustomLoaderState();
}

class CustomLoaderState extends State<DotLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.shortestSide;
    double size = screenSize * 0.1;
    double strokeWidth = size * 0.1;

    return SizedBox(
      width: size,
      height: size,
      child: RotationTransition(
        turns: _controller,
        child: CustomPaint(
          painter: _GapCircularLoaderPainter(
            color: widget.loaderColor,
            strokeWidth: strokeWidth,
          ),
          child: Container(),
        ),
      ),
    );
  }
}

class _GapCircularLoaderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _GapCircularLoaderPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = min(size.width, size.height) / 2;
    const double gapAngle = pi / 2;
    const double segmentAngle = pi / 2;

    for (double startAngle = 0; startAngle < 2 * pi; startAngle += segmentAngle + gapAngle) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        segmentAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
