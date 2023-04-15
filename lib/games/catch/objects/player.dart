import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/games/catch/objects/fall_item.dart';
import 'package:to_walk_app/games/common.dart';

class PlayerObject extends BodyComponent<CatchGame> with ContactCallbacks {
  double tapX = 0;
  double accelerationX = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    double center = worldSize.x / 2;
    tapX = double.parse(center.toStringAsFixed(1));
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(worldSize.x / 2, worldSize.y - 2),
      type: BodyType.dynamic,
    );
    final shape = PolygonShape()..setAsBoxXY(.5, .5);
    final fixtureDef = FixtureDef(shape)
      ..density = 10
      ..friction = 0
      ..restitution = 0;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setFixedRotation(true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final velocity = body.linearVelocity;
    final positionX = double.parse(body.position.x.toStringAsFixed(1));
    if (positionX > tapX) {
      accelerationX = -1;
    } else if (positionX < tapX) {
      accelerationX = 1;
    } else {
      accelerationX = 0;
    }
    velocity.x = accelerationX * 1;
    body.linearVelocity = velocity;
  }

  void move(double value) async {
    await Future.delayed(const Duration(seconds: 1));
    tapX = double.parse(value.toStringAsFixed(1));
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is FallItemObject) {
      other.collision();
      findGame()?.overlays.add('GameEnd');
      findGame()?.paused = true;
    }
  }
}
