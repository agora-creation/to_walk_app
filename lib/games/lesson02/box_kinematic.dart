import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/lesson01/game.dart';

class BoxKinematic extends BodyComponent {
  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: Vector2(screenSize.x / 2, screenSize.y / 2),
      type: BodyType.kinematic,
    );
    final shape = PolygonShape()..setAsBoxXY(.15, 1.25);
    final fixtureDef = FixtureDef(shape);
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..angularVelocity = radians(180);
  }
}
