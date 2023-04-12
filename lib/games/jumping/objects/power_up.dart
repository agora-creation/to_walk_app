import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/jumping/assets.dart';
import 'package:to_walk_app/games/jumping/game.dart';

enum PowerUpType { jetpack, bubble, gun }

extension PowerUpExtension on PowerUpType {
  Sprite get sprite {
    switch (this) {
      case PowerUpType.jetpack:
        return Assets.jetpackSmall;
      case PowerUpType.bubble:
        return Assets.bubbleSmall;
      case PowerUpType.gun:
        return Assets.gun;
    }
  }
}

class PowerUp extends BodyComponent<JumpingGame> {
  static Vector2 size = Vector2(.25, .35);
  final Vector2 _position;
  bool isTaken = false;
  final PowerUpType type;

  PowerUp({
    required double x,
    required double y,
  })  : _position = Vector2(x, y),
        type = PowerUpType.values.elementAt(
          Random().nextInt(PowerUpType.values.length),
        );

  void take() => isTaken = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //renderBody = false;
    add(SpriteComponent(
      sprite: type.sprite,
      size: size,
      anchor: Anchor.center,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    bool isOutOfScreen = gameRef.isOutOfScreen(body.position);
    if (isTaken || isOutOfScreen) {
      world.destroyBody(body);
      gameRef.remove(this);
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: _position,
      type: BodyType.static,
    );
    final shape = PolygonShape()..setAsBoxXY(.58, .23);
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
