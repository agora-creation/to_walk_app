import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class JoystickPlayer extends SpriteComponent with HasGameRef {
  double maxSpeed = 300;

  static final _paint = Paint()..color = Colors.transparent;

  RectangleComponent muzzleComponent = RectangleComponent(
    size: Vector2(1, 1),
    paint: _paint,
  );

  final JoystickComponent joystick;

  JoystickPlayer(this.joystick) : super(size: Vector2.all(35)) {
    anchor = Anchor.center;
  }

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
    super.update(dt);
    if (!joystick.delta.isZero()) {
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
  }
}
