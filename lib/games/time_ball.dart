import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart' hide Image, Draggable;
import 'package:to_walk_app/games/fourth.dart';
import 'package:to_walk_app/games/lifebar_text.dart';

class TimeBall extends CircleComponent
    with HasGameRef<FourthGame>, CollisionCallbacks {
  final _collisionColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  Color _currentColor = Colors.cyan;
  bool _isWallHit = false;
  bool _isCollision = false;
  late double _speed;
  late LifeBarText _healthText;

  int xDirection = 1;
  int yDirection = 1;

  int _life = 100;

  Map<String, TimeBall> collisions = {};

  TimeBall(
    Vector2 position,
    Vector2 velocity,
    double speed,
    int ordinalNumber,
  ) : super(
          position: position,
          radius: 20,
          anchor: Anchor.center,
        ) {
    xDirection = velocity.x.toInt();
    yDirection = velocity.y.toInt();
    _speed = speed;
    add(CircleHitbox());
    _healthText = LifeBarText(ordinalNumber)
      ..x = 0
      ..y = -size.y / 2;
  }

  @override
  Future onLoad() async {
    await FlameAudio.audioCache.load('ball_bounce_off_ball.ogg');
    add(_healthText);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    List keys = [];
    for (var other in collisions.entries) {
      TimeBall otherObject = other.value;
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
      _isWallHit = true;
    }
    if ((rect.top <= 0 && yDirection == -1) ||
        (rect.bottom >= gameRef.size.y && yDirection == 1)) {
      yDirection = yDirection * -1;
      _isWallHit = true;
    }

    _currentColor = _isCollision ? _collisionColor : _defaultColor;
    if (_isCollision) {
      _life -= 10;
      _isCollision = false;
    }
    if (_isWallHit) {
      _life -= 10;
      _isWallHit = false;
    }
    _healthText.healthData = _life;
    if (_life <= 0) {
      parent?.remove(this);
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
    if (other is TimeBall) {
      if (collisions.containsKey(other.hashCode.toString())) {
      } else {
        collisions[other.hashCode.toString()] = other;

        xDirection = xDirection * -1;
        yDirection = yDirection * -1;

        String collisionKey;
        if (hashCode > other.hashCode) {
          collisionKey = other.hashCode.toString() + hashCode.toString();
        } else {
          collisionKey = hashCode.toString() + other.hashCode.toString();
        }
        if (gameRef.observedCollisions.contains(collisionKey)) {
          gameRef.observedCollisions.remove(collisionKey);
        } else {
          gameRef.observedCollisions.add(collisionKey);
          FlameAudio.play('ball_bounce_off_ball.ogg');
        }

        _isCollision = true;
      }
    }
  }
}
