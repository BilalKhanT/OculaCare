
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/routes/route_names.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  const GameOverScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go(RouteNames.trackInitialRoute);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$score', style: TextStyle(fontSize: 24),),
          ],
        ),
      ),
    );
  }
}
