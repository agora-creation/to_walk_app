import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/helpers/common.dart';

class GroundObject extends BodyComponent<CatchGame> {
  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(0, worldSize.y),
      type: BodyType.static,
    );
    final shape = EdgeShape()..set(Vector2.zero(), Vector2(worldSize.x, 0));
    final fixtureDef = FixtureDef(shape);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
