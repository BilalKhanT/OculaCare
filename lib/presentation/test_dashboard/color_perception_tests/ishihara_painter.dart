import 'dart:math';

import 'package:flutter/material.dart';

class IshiharaPainter extends CustomPainter {
  final int number;
  final Color digitColor;
  final Random _random = Random();

  IshiharaPainter(this.number, this.digitColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    _draw3DCircle(canvas, center, radius);
    _drawDots(canvas, center, radius);
    _drawNumber(canvas, center, radius);
  }

  void _draw3DCircle(Canvas canvas, Offset center, double radius) {
    final Rect circleRect = Rect.fromCircle(center: center, radius: radius);

    final Gradient gradient = RadialGradient(
      colors: [
        Colors.grey.shade300,
        Colors.grey.shade800,
      ],
      center: Alignment.topLeft,
      radius: 1.0,
    );

    final Paint paint = Paint()..shader = gradient.createShader(circleRect);
    canvas.drawCircle(center, radius, paint);

    canvas.drawShadow(
      Path()..addOval(circleRect),
      Colors.grey,
      8.0,
      false,
    );
  }

  void _drawDots(Canvas canvas, Offset center, double radius) {
    const int dotCount = 1500;
    for (int i = 0; i < dotCount; i++) {
      final double angle = _random.nextDouble() * 2 * pi;
      final double distance = sqrt(_random.nextDouble()) * radius;
      final Offset offset = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance,
      );
      final Color color = _getRandomColor();
      canvas.drawCircle(offset, 5, Paint()..color = color.withOpacity(0.85));
    }
  }

  // Function to draw the outlined number.
  void _drawNumber(Canvas canvas, Offset center, double radius) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: number.toString(),
        style: TextStyle(
          fontSize: radius * 1.1,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..color = digitColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}