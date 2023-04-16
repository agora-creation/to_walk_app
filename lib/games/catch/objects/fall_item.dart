import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/games/catch/objects/ground.dart';
import 'package:to_walk_app/games/catch/objects/player.dart';

class FallItemObject extends BodyComponent<CatchGame> with ContactCallbacks {
  final Vector2 _position;
  bool isCollision = false;

  FallItemObject({
    required double x,
    required double y,
  }) : _position = Vector2(x, y);

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: _position,
      type: BodyType.dynamic,
    );
    final shape = CircleShape()..radius = .3;
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..gravityScale = Vector2(0, .1);
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
    isCollision = true;
    if (other is GroundObject) {
      gameRef.controller.addScore(50);
      findGame()?.overlays.add('GameEnd');
      findGame()?.paused = true;
    }
    if (other is PlayerObject) {
      gameRef.camera.shake(duration: 0.5, intensity: 5);
    }
    super.beginContact(other, contact);
  }
}
