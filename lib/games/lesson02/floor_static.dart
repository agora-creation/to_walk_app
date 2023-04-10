import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/lesson01/game.dart';

class FloorStatic extends BodyComponent {
  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: Vector2(0, screenSize.y - 1),
      type: BodyType.static,
    );
    final shape = EdgeShape()
      ..set(
        Vector2.zero(),
        Vector2(screenSize.x, 0),
      );
    final fixtureDef = FixtureDef(shape);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
