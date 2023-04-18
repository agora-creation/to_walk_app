import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/jump/game.dart';
import 'package:to_walk_app/games/jump/objects/player.dart';

class CloudObject extends BodyComponent<JumpGame> with ContactCallbacks {
  final Vector2 _position;
  final int time;

  CloudObject({
    required double y,
    required this.time,
  }) : _position = Vector2(worldSize.x + 1, y);

  @override
  void update(double dt) {
    super.update(dt);
    if (body.position.x < -1) {
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
    final shape = PolygonShape()..setAsBoxXY(.5, .3);
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..linearVelocity = Vector2(-1, 0);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is PlayerObject) {
      gameRef.controller.gameFinish();
    }
  }
}
