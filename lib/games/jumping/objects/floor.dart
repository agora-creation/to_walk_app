import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/jumping/game.dart';

class Floor extends BodyComponent<JumpingGame> {
  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.isOutOfScreen(body.position)) {
      world.destroyBody(body);
      gameRef.remove(this);
    }
  }

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
