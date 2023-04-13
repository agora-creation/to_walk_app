import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/helpers/common.dart';

class PlayerObject extends BodyComponent<CatchGame> {
  double accelerationX = 0;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(worldSize.x / 2, worldSize.y - 2),
      type: BodyType.dynamic,
    );
    final shape = PolygonShape()..setAsBoxXY(.5, .5);
    final fixtureDef = FixtureDef(shape)
      ..density = 10
      ..friction = 0
      ..restitution = 0;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setFixedRotation(true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final velocity = body.linearVelocity;
    final position = body.position;

    velocity.x = accelerationX * 2;
    body.linearVelocity = velocity;

    if (position.x > worldSize.x) {
      position.x = worldSize.x;
      body.setTransform(position, 0);
    } else if (position.x < 0) {
      position.x = 0;
      body.setTransform(position, 0);
    }
  }

  void moveLeft() async {
    await Future.delayed(const Duration(seconds: 1));
    accelerationX = -1;
  }

  void moveRight() async {
    await Future.delayed(const Duration(seconds: 1));
    accelerationX = 1;
  }
}
