import 'package:flame/components.dart';

class Obstacle extends SpriteComponent {
  final String type;

  Obstacle(
      {required Vector2 position, required this.type, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center);

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('$type.png');
  }
}
