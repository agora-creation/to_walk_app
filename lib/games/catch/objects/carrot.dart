import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/games/catch/objects/player.dart';
import 'package:to_walk_app/games/resources.dart';

class CarrotObject extends BodyComponent<CatchGame> with ContactCallbacks {
  static final size = Vector2(.5, 1.25);
  final Vector2 _position;
  final double gravity;
  final int time;
  bool isCollision = false;

  CarrotObject({
    required double x,
    required this.gravity,
    required this.time,
  }) : _position = Vector2(x, -1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(SpriteComponent(
      sprite: Resources.catchCarrot,
      size: size,
      anchor: Anchor.center,
    ));
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: _position,
      type: BodyType.dynamic,
    );
    final shape = PolygonShape()..setAsBoxXY(.2, .6);
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..gravityScale = Vector2(0, gravity);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isCollision) {
      world.destroyBody(body);
      gameRef.remove(this);
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    isCollision = true;
    if (other is PlayerObject) {
      gameRef.controller.addScore(1);
    }
    gameRef.controller.currentCarrots.remove(this);
  }
}
