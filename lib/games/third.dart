import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Image, Draggable;

class ThirdGame extends FlameGame with HasCollisionDetection, TapDetector {
  int thresholdOutOfBounds = 20;

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

class MyCollidable extends CircleComponent
    with HasGameRef<ThirdGame>, CollisionCallbacks {
  final _collisionColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  Color _currentColor = Colors.cyan;
  bool _isWallHit = false;
  bool _isCollision = false;
  final double _speed = 200;

  int xDirection = 1;
  int yDirection = 1;

  Map<String, MyCollidable> collisions = {};

  MyCollidable(Vector2 position)
      : super(
          position: position,
          radius: 5,
          anchor: Anchor.center,
        ) {
    add(CircleHitbox());
  }

  @override
  Future onLoad() async {
    await super.onLoad();
    final center = gameRef.size / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    List keys = [];
    for (var other in collisions.entries) {
      MyCollidable otherObject = other.value;
      if (distance(otherObject) > size.x) {
        keys.add(other.key);
      }
    }
    collisions.removeWhere((key, value) => keys.contains(key));
    x += xDirection * _speed * dt;
    y += yDirection * _speed * dt;
    final rect = toRect();
    if ((rect.left <= 0 && xDirection == -1) ||
        (rect.right >= gameRef.size.x && xDirection == 1)) {
      xDirection = xDirection * -1;
    }
    if ((rect.top <= 0 && yDirection == -1) ||
        (rect.bottom >= gameRef.size.y && yDirection == 1)) {
      yDirection = yDirection * -1;
    }
    _currentColor = _isCollision ? _collisionColor : _defaultColor;
    if (_isCollision && !_isWallHit) {
      _isCollision = false;
    }
    if (_isWallHit) {
      _isWallHit = false;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    paint = Paint()..color = _currentColor;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is MyCollidable) {
      if (collisions.containsKey(other.hashCode.toString())) {
      } else {
        collisions[other.hashCode.toString()] = other;
      }
      xDirection = xDirection * -1;
      yDirection = yDirection * -1;
    }
    _isCollision = true;
  }
}