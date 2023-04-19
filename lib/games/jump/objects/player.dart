import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/jump/game.dart';

class PlayerObject extends BodyComponent<JumpGame> {
  final int level;
  bool isDead = false;

  PlayerObject({required this.level});

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(worldSize.x / 4, worldSize.y / 2),
      type: BodyType.dynamic,
    );
    final shape = CircleShape()..radius = .5;
    final fixtureDef = FixtureDef(shape)
      ..density = 10
      ..friction = 0
      ..restitution = 0;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setFixedRotation(true);
  }

  void jump() {
    if (!isDead) {
      double jump = (level * -1) * 0.5;
      final velocity = body.linearVelocity;
      body.linearVelocity = Vector2(velocity.x, jump);
    }
  }

  void dead() => isDead = true;
}
