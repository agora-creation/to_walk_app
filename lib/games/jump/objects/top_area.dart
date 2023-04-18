import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/jump/game.dart';

class TopArea extends BodyComponent<JumpGame> {
  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(0, -1),
      type: BodyType.static,
    );
    final shape = PolygonShape()..setAsBoxXY(worldSize.x, 1);
    final fixtureDef = FixtureDef(shape);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
