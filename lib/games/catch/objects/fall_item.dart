import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/catch/game.dart';

class FallItemObject extends BodyComponent<CatchGame> {
  Vector2 _position;

  FallItemObject({
    required double x,
    required double y,
  }) : _position = Vector2(x, y);

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: _position,
      type: BodyType.kinematic,
    );
    final shape = CircleShape()..radius = .5;
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..linearVelocity = Vector2(0, 1);
  }
}
