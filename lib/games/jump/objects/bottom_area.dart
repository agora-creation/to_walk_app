import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/jump/game.dart';
import 'package:to_walk_app/games/jump/objects/player.dart';

class BottomArea extends BodyComponent<JumpGame> with ContactCallbacks {
  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(0, worldSize.y + 2),
      type: BodyType.static,
    );
    final shape = PolygonShape()..setAsBoxXY(worldSize.x, 1);
    final fixtureDef = FixtureDef(shape);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is PlayerObject) {
      game.controller.gameFinish();
    }
  }
}
