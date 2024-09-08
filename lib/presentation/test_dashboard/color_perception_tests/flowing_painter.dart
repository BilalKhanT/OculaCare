import 'package:flutter/material.dart';

class FlowingWavePaint extends StatefulWidget {
  final Color color;
  final bool shouldAnimate;

  const FlowingWavePaint(
      {super.key, required this.color, required this.shouldAnimate});

  @override
  FlowingWavePaintState createState() => FlowingWavePaintState();
}

class FlowingWavePaintState extends State<FlowingWavePaint>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _flowController;
  late Animation<double> _waveAnimation;
  late Animation<double> _flowAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _waveAnimation = CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    );

    _flowAnimation = Tween<double>(begin: -1, end: 0).animate(
      CurvedAnimation(
        parent: _flowController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.shouldAnimate) {
      _flowController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant FlowingWavePaint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color && widget.shouldAnimate) {
      _flowController.reset();
      _flowController.forward();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _flowController.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget? widget) {
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * _flowAnimation.value,
          left: 0,
          right: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: WavePainter(
                controller: _waveAnimation,
                waves: 2,
                waveAmplitude: 45,
                color: this.widget.color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_waveController, _flowController]),
      builder: _buildAnimation,
    );
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> controller;
  final int waves;
  final double waveAmplitude;
  final Color color;

  WavePainter({
    required this.controller,
    required this.waves,
    required this.waveAmplitude,
    required this.color,
  });

  int get waveSegments => 2 * waves - 1;

  void drawWave(Path path, int wave, Size size) {
    double waveWidth = size.width / waveSegments;
    double waveMinHeight = size.height;

    double x1 = wave * waveWidth + waveWidth / 2;
    double y1 = waveMinHeight - (wave.isOdd ? waveAmplitude : -waveAmplitude);

    double x2 = x1 + waveWidth / 2;
    double y2 = waveMinHeight;

    path.quadraticBezierTo(x1, y1, x2, y2);

    if (wave <= waveSegments) {
      drawWave(path, wave + 1, size);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path()..moveTo(0, size.height);
    drawWave(path, 0, size);

    double waveWidth = (size.width / waveSegments) * 2;
    path
      ..lineTo(size.width + waveWidth, 0)
      ..lineTo(0, 0)
      ..close();

    Path shiftedPath = path.shift(Offset(-controller.value * waveWidth, 0));

    canvas.drawPath(shiftedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
