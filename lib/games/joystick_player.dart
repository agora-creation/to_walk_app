import 'package:flame/components.dart';
import 'package:to_walk_app/games/utils.dart';

class JoystickPlayer extends SpriteComponent with HasGameRef {
  double maxSpeed = 300;

  final JoystickComponent joystick;

  JoystickPlayer(this.joystick)
      : super(
          size: Vector2.all(50),
        ) {
    anchor = Anchor.center;
  }

  @override
  Future onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('asteroids_ship.png');
    position = gameRef.size / 2;
  }

  @override
  void update(double dt) {
    if (!joystick.delta.isZero()) {
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = (joystick.delta.screenAngle());
      if (Utils.isPositionOutOfBounds(gameRef.size, position)) {
        position = Utils.wrapPosition(gameRef.size, position);
      }
    }
  }
}
