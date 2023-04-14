import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/jumping/assets.dart';
import 'package:to_walk_app/games/jumping/game.dart';
import 'package:to_walk_app/games/jumping/objects/lightning.dart';

const double _timeForNextLightning = 5;

class CloudEnemy extends BodyComponent<JumpingGame> {
  static Vector2 size = Vector2(1.55, .83);
  final double speed = 1 + (1 * Random().nextDouble());
  double timeForNextLightning = _timeForNextLightning * Random().nextDouble();
  Vector2 _position;
  bool destroy = false;

  CloudEnemy({
    required double x,
    required double y,
  }) : _position = Vector2(x, y);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //renderBody = false;
    add(SpriteComponent(
      sprite: Assets.cloudHappyEnemy,
      anchor: Anchor.center,
      size: size,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _position = body.position;
    if (_position.x > worldSize.x) {
      body.linearVelocity = Vector2(-speed, 0);
    } else if (_position.x < 0) {
      body.linearVelocity = Vector2(speed, 0);
    }
    timeForNextLightning += dt;
    if (timeForNextLightning > _timeForNextLightning) {
      timeForNextLightning -= _timeForNextLightning;
      gameRef.add(Lightning(
        x: _position.x,
        y: _position.y + 0.5,
      ));
    }
    bool isOutOfScreen = gameRef.isOutOfScreen(body.position);
    if (destroy || isOutOfScreen) {
      world.destroyBody(body);
      gameRef.remove(this);
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: _position,
      type: BodyType.kinematic,
    );
    final rndSpeed = Random().nextBool() ? speed : -speed;
    final shape = PolygonShape()..setAsBoxXY(.3, .2);
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..linearVelocity = Vector2(rndSpeed, 0);
  }
}
