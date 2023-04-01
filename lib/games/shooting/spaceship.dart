import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/bullet.dart';
import 'package:to_walk_app/games/shooting/game.dart';

class Spaceship extends SpriteComponent with HasGameRef<ShootingGame> {
  double maxSpeed = 300;

  final BulletEnum _currentBulletType = BulletEnum.fastBullet;

  static final _paint = Paint()..color = Colors.transparent;

  RectangleComponent muzzleComponent = RectangleComponent(
    size: Vector2(1, 1),
    paint: _paint,
  );

  final JoystickComponent joystick;

  Spaceship(this.joystick) : super(size: Vector2.all(35)) {
    anchor = Anchor.center;
  }

  BulletEnum get getBulletType => _currentBulletType;

  @override
  Future onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('asteroids_ship.png');
    position = gameRef.size / 2;

    muzzleComponent.position.x = size.x / 2;
    muzzleComponent.position.y = size.y / 10;

    add(muzzleComponent);
  }

  @override
  void update(double dt) {
    if (!joystick.delta.isZero()) {
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
    super.update(dt);
  }
}
