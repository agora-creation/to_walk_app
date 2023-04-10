import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/lesson01/game.dart';

class BallDynamic extends BodyComponent {
  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: Vector2(screenSize.x / 2, 0),
      type: BodyType.dynamic,
    );
    final shape = CircleShape()..radius = .35;
    final fixtureDef = FixtureDef(shape);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
