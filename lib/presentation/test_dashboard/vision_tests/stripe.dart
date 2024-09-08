import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'dart:math';

import '../../../logic/tests/vision_tests/animal_track_cubit.dart';

class SpriteClass extends SpriteAnimationComponent
    with TapCallbacks, HasGameRef {
  final double speed;
  final String type;
  final AnimalTrackCubit cubit;
  final Random _random = Random();
  Vector2 velocity;

  SpriteClass({
    required Vector2 size,
    required this.speed,
    required this.cubit,
    required this.type,
  })  : velocity = Vector2.zero(),
        super(size: size, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    switch (type) {
      case 'dragon':
        animation = await _loadAnimation('dragfly.png', 3, 0.1);
        break;
      case 'parrot':
        animation = await _loadAnimation('twindrag.png', 3, 0.1);
        break;
      case 'bird':
        animation = await _loadAnimation('sting.png', 4, 0.1);
        break;
      default:
        throw Exception('Invalid type: $type');
    }

    randomizePosition();
    randomizeVelocity();
  }

  Future<SpriteAnimation> _loadAnimation(
      String path, int frameCount, double stepTime) async {
    final spriteSheet = await gameRef.images.load(path);
    final spriteSize =
        Vector2(spriteSheet.width / frameCount, spriteSheet.height.toDouble());
    return SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: frameCount,
        textureSize: spriteSize,
        stepTime: stepTime,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    if (velocity.length > 0) {
      double currentAngle = velocity.angleTo(Vector2(0, -1));

      if (velocity.x < 0) {
        scale.x = -1;
        angle = -currentAngle;
      } else {
        scale.x = 1;
        angle = currentAngle;
      }
    }

    if (position.x < 0) {
      position.x = gameRef.size.x;
    } else if (position.x > gameRef.size.x) {
      position.x = 0;
    }

    if (position.y < 0) {
      position.y = gameRef.size.y;
    } else if (position.y > gameRef.size.y) {
      position.y = 0;
    }
  }

  void randomizePosition() {
    position = Vector2(
      _random.nextDouble() * gameRef.size.x,
      _random.nextDouble() * gameRef.size.y,
    );
  }

  void randomizeVelocity() {
    double angle = _random.nextDouble() * 2 * pi;
    velocity = Vector2(cos(angle), sin(angle)) * speed;
  }

  @override
  void onTapDown(TapDownEvent event) {
    cubit.incrementScore();
    randomizePosition();
    randomizeVelocity();
  }
}
