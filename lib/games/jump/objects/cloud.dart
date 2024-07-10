import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/jump/game.dart';
import 'package:to_walk_app/games/jump/objects/player.dart';
import 'package:to_walk_app/games/resources.dart';

class CloudObject extends BodyComponent<JumpGame> with ContactCallbacks {
  static final size = Vector2(1.5, .8);
  final Vector2 _position;
  final int time;
  final double speed;

  CloudObject({
    required double y,
    required this.time,
    required this.speed,
  }) : _position = Vector2(worldSize.x + 1, y);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    add(SpriteComponent(
      sprite: Resources.jumpCloud,
      size: size,
      anchor: Anchor.center,
    ));
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: _position,
      type: BodyType.kinematic,
    );
    final shape = PolygonShape()..setAsBoxXY(.6, .3);
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..linearVelocity = Vector2(-1 * speed, 0);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (body.position.x < -1) {
      world.destroyBody(body);
      game.remove(this);
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is PlayerObject) {
      game.controller.gameFinish();
    }
  }
}
