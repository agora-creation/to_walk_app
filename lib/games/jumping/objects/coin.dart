import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/jumping/assets.dart';
import 'package:to_walk_app/games/jumping/game.dart';

class Coin extends BodyComponent<JumpingGame> {
  static Vector2 size = Vector2(.26, .36);
  final Vector2 _position;
  bool isTaken = false;

  Coin({
    required double x,
    required double y,
  }) : _position = Vector2(x, y);

  void take() => isTaken = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //renderBody = false;
    add(SpriteComponent(
      sprite: Assets.coin,
      size: size,
      anchor: Anchor.center,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    bool isOutOfScreen = gameRef.isOutOfScreen(body.position);
    if (isTaken || isOutOfScreen) {
      world.destroyBody(body);
      gameRef.remove(this);
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: _position,
      type: BodyType.static,
    );
    final shape = PolygonShape()..setAsBoxXY(.13, .16);
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}