import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/resources.dart';

class GroundObject extends BodyComponent<CatchGame> {
  static Vector2 size = Vector2(worldSize.x, 1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    add(SpriteComponent(
      sprite: Resources.catchGround,
      size: size,
      anchor: Anchor.center,
    ));
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(worldSize.x / 2, worldSize.y - 0.5),
      type: BodyType.static,
    );
    final shape = PolygonShape()..setAsBoxXY(size.x / 2, (size.y / 2) - 0.1);
    final fixtureDef = FixtureDef(shape);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
