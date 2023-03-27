import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Bullet extends PositionComponent {
  static final _paint = Paint()..color = Colors.white;
  final double _speed = 150;
  late Vector2 _velocity;

  Bullet(Vector2 position, Vector2 velocity)
      : _velocity = velocity,
        super(
          position: position,
          size: Vector2.all(4),
          anchor: Anchor.center,
        );

  @override
  Future onLoad() async {
    await super.onLoad();
    _velocity = (_velocity)..scaleTo(_speed);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  void update(double dt) {
    position.add(_velocity * dt);
  }
}
