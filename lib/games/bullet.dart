import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/utils.dart';

class Bullet extends PositionComponent {
  static final _paint = Paint()..color = Colors.white;
  final double _speed = 150;
  late Vector2 _velocity;
  late final Vector2 _bounds;

  Bullet(Vector2 position, Vector2 velocity, Vector2 bounds)
      : _velocity = velocity,
        _bounds = bounds,
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
    if (Utils.isPositionOutOfBounds(_bounds, position)) {
      removeFromParent();
    }
  }
}
