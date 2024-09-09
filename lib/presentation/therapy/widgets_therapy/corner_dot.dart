import 'package:flutter/material.dart';

class CornerDot extends StatelessWidget {
  final List<Offset> dotPositions;
  final double dotOpacity;

  const CornerDot({
    Key? key,
    required this.dotPositions,
    required this.dotOpacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: dotPositions.map((position) {
        return Positioned(
          left: position.dx *
              MediaQuery.of(context).size.width, // Horizontal position
          top: position.dy *
              MediaQuery.of(context).size.height, // Vertical position
          child: AnimatedOpacity(
            opacity: dotOpacity,
            duration: const Duration(milliseconds: 500), // Smooth transition
            child: Container(
              width: 50, // Size of the dot
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.blue, // Dot color
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
