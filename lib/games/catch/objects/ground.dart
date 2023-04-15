import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/games/catch/objects/fall_item.dart';
import 'package:to_walk_app/games/common.dart';

class GroundObject extends BodyComponent<CatchGame> with ContactCallbacks {
  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(0, worldSize.y - 1),
      type: BodyType.static,
    );
    final shape = EdgeShape()..set(Vector2.zero(), Vector2(worldSize.x, 0));
    final fixtureDef = FixtureDef(shape);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is FallItemObject) {
      other.collision();
    }
  }
}
