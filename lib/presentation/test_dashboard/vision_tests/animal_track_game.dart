import 'package:OculaCare/configs/global/app_globals.dart';
import 'package:OculaCare/data/models/tests/score_model.dart';
import 'package:OculaCare/presentation/test_dashboard/vision_tests/pause_menu.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../../../configs/routes/route_names.dart';
import '../../../logic/tests/vision_tests/animal_track_cubit.dart';
import 'stripe.dart';
import 'dart:async' as dart_async;
import 'obstacle.dart';
import 'package:flutter/material.dart';

class AnimalTrackGame extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  final BuildContext context;
  final AnimalTrackCubit gameCubit;
  late SpriteClass stripe;
  final List<Obstacle> _obstacles = [];
  int level = 1;
  double stripeSize = 150;
  double speed = 150;
  final ValueNotifier<int> timeLeft = ValueNotifier<int>(10);
  dart_async.Timer? levelTimer;

  AnimalTrackGame(this.gameCubit, this.context) {
    overlays.addEntry(
      'PauseMenu',
      (BuildContext context, Game game) {
        final animalTrackGame = game as AnimalTrackGame;
        return PauseMenu(
          onResume: animalTrackGame.resumeGame,
          onQuit: () {
            ScoreModel score = gameCubit.endGame();
            navigateToGameOverScreen(score);
          },
        );
      },
    );
  }

  @override
  Future<void> onLoad() async {
    startLevel();
    addContinuousSnowfall();
    addOverlayButton();
  }

  void addOverlayButton() {
    final overlayButton = CustomButtonComponent(
      onPressed: showPauseOverlay,
      position: Vector2(size.x - 40, 50),
    );
    add(overlayButton);
  }

  void showPauseOverlay() {
    pauseEngine();
    levelTimer?.cancel();
    overlays.add('PauseMenu');
  }

  void resumeGame() {
    overlays.remove('PauseMenu');
    resumeEngine();
    startLevelTimer();
  }

  void addContinuousSnowfall() {
    final snowTimer = TimerComponent(
      period: 0.2,
      repeat: true,
      onTick: () {
        final snowParticle = ParticleSystemComponent(
          particle: Particle.generate(
            count: 10,
            lifespan: 3,
            generator: (i) => MovingParticle(
              from: Vector2(
                Random().nextDouble() * size.x,
                -10,
              ),
              to: Vector2(
                Random().nextDouble() * size.x,
                size.y + 10,
              ),
              child: CircleParticle(
                radius: 2 + Random().nextDouble() * 2,
                paint: Paint()..color = Colors.grey.shade300,
              ),
            ),
          ),
          position: Vector2.zero(),
          size: size,
          priority: -1,
        );

        add(snowParticle);
      },
    );

    add(snowTimer);
  }

  void startLevel() {
    removeAllComponents();

    levelTimer?.cancel();

    timeLeft.value = 30;

    startLevelTimer();

    addObstacles();

    String type = getStripeTypeForLevel(level);
    stripe = SpriteClass(
      type: type,
      size: Vector2(stripeSize, stripeSize),
      speed: speed,
      cubit: gameCubit,
    );
    add(stripe);
  }

  String getStripeTypeForLevel(int level) {
    switch (level) {
      case 1:
        return 'dragon';
      case 2:
        return 'parrot';
      default:
        return 'bird';
    }
  }

  void startLevelTimer() {
    levelTimer = dart_async.Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value -= 1;
      } else {
        timer.cancel();
        levelTimer = null;
        if (level < 3) {
          level++;
          trackLevel += 1;
          stripeSize /= 2;
          speed += 50;
          startLevel();
          addContinuousSnowfall();
          addOverlayButton();
        } else {
          ScoreModel score = gameCubit.endGame();
          navigateToGameOverScreen(score);
        }
      }
    });
  }

  void removeAllComponents() {
    children.whereType<Component>().toList().forEach((component) {
      component.removeFromParent();
    });
  }

  @override
  Color backgroundColor() => Colors.white;

  void addObstacles() {
    _obstacles.clear();

    List<String> obstacleTypes = ['tree', 'obstacle'];
    List<Vector2> positions = [
      Vector2(50, 50),
      Vector2(200, 100),
      Vector2(350, 200),
      Vector2(500, 300),
      Vector2(100, 400),
      Vector2(250, 500),
      Vector2(400, 600),
      Vector2(600, 150),
      Vector2(750, 250),
      Vector2(900, 350),
      Vector2(50, 700),
      Vector2(250, 750),
      Vector2(450, 850),
      Vector2(650, 900),
      Vector2(850, 950),
    ];

    Vector2 obstacleSize = Vector2(150, 150);

    for (int i = 0; i < positions.length; i++) {
      String type = obstacleTypes[i % obstacleTypes.length];
      final obstacle = Obstacle(
        position: positions[i],
        type: type,
        size: obstacleSize,
      );
      add(obstacle);
      _obstacles.add(obstacle);
    }
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    final position = event.localPosition;
    if (stripe.containsPoint(position)) {
      gameCubit.incrementScore();
      stripe.randomizePosition();
      stripe.randomizeVelocity();
    } else {
      gameCubit.incrementMistaps();
      if (gameCubit.state.mistaps >= 5) {
        ScoreModel score = gameCubit.endGame();
        navigateToGameOverScreen(score);
      }
    }
  }

  void navigateToGameOverScreen(ScoreModel score) {
    context.go(RouteNames.trackGameOverRoute, extra: score);

    overlays.clear();
    removeFromParent();
    pauseEngine();
  }

  ValueNotifier<int> get timeLeftNotifier => timeLeft;
}

class CustomButtonComponent extends PositionComponent with TapCallbacks {
  final VoidCallback onPressed;

  CustomButtonComponent({required this.onPressed, required Vector2 position})
      : super(position: position);

  @override
  Future<void> onLoad() async {
    size = Vector2(40, 40);
    anchor = Anchor.center;
    await super.onLoad();
  }

  @override
  bool onTapDown(TapDownEvent event) {
    onPressed();
    return true;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.black;
    const dotRadius = 4.0;
    const spacing = 12.0;

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2 - spacing + i * spacing),
        dotRadius,
        paint,
      );
    }
  }
}
