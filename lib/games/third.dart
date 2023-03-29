import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Image, Draggable;

class ThirdGame extends FlameGame with HasCollisionDetection, TapDetector {
  @override
  Future onLoad() async {
    await super.onLoad();
    add(ScreenHitbox());
  }

  @override
  void onTapDown(TapDownInfo info) {
    add(MyCollidable(info.eventPosition.game));
  }
}

class MyCollidable extends PositionComponent
    with HasGameRef<ThirdGame>, GestureHitboxes, CollisionCallbacks {
  late Vector2 velocity;
  final _collisionColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  Color _currentColor = Colors.cyan;
  bool _isWallHit = false;
  bool _isCollision = false;
  final double _speed = 50;

  MyCollidable(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(16),
          anchor: Anchor.center,
        ) {
    add(CircleHitbox());
  }

  @override
  Future onLoad() async {
    await super.onLoad();
    final center = gameRef.size / 2;
    velocity = (center - position)..scaleTo(_speed);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isWallHit) {
      removeFromParent();
      return;
    } else {
      _currentColor = _isCollision ? _collisionColor : _defaultColor;
      position.add(velocity * dt);
      _isCollision = false;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final localCenter = (scaledSize / 2).toOffset();
    canvas.drawCircle(localCenter, 8, Paint()..color = _currentColor);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ScreenHitbox) {
      _isWallHit = true;
      return;
    }
    _isCollision = true;
  }
}
