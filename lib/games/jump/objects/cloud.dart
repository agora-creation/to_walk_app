import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/jump/game.dart';

class CloudObject extends BodyComponent<JumpGame> {
  @override
  void update(double dt) {
    super.update(dt);
    if (body.position.x < 0) {
      world.destroyBody(body);
      gameRef.remove(this);
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(10, 5),
      type: BodyType.kinematic,
    );
    final shape = PolygonShape()..setAsBoxXY(.5, .3);
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..linearVelocity = Vector2(-1, 0);
  }
}
