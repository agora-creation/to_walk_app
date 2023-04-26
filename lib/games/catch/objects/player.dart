import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/resources.dart';

enum PlayerState {
  idle,
  walk,
  dead,
}

class PlayerObject extends BodyComponent<CatchGame> {
  static final size = Vector2(.8, .8);
  double tapX = 0;
  double accelerationX = 0;
  PlayerState state = PlayerState.idle;
  late final SpriteComponent idleComponent;
  late final SpriteAnimationComponent walkComponent;
  late final SpriteComponent deadComponent;
  late Component currentComponent;
  final int level;

  PlayerObject({required this.level});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    idleComponent = SpriteComponent(
      sprite: Resources.catchPlayerIdle,
      size: size,
      anchor: Anchor.center,
    );
    walkComponent = SpriteAnimationComponent(
      animation: Resources.catchPlayerWalk,
      size: size,
      anchor: Anchor.center,
    );
    deadComponent = SpriteComponent(
      sprite: Resources.catchPlayerDead,
      size: size,
      anchor: Anchor.center,
    );
    currentComponent = idleComponent;
    add(currentComponent);
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
    final shape = CircleShape()..radius = .35;
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
      state = PlayerState.walk;
    } else if (positionX < tapX) {
      accelerationX = 1;
      state = PlayerState.walk;
    } else {
      accelerationX = 0;
      state = PlayerState.idle;
    }
    double speed = level * 0.2;
    velocity.x = accelerationX * speed;
    body.linearVelocity = velocity;
    if (state == PlayerState.idle) {
      _setComponent(idleComponent);
    } else if (state == PlayerState.walk) {
      _setComponent(walkComponent);
    } else if (state == PlayerState.dead) {
      _setComponent(deadComponent);
    }
  }

  void move(double value) async {
    int milliseconds = 500;
    if (0 < level && level <= 10) {
      milliseconds = 500;
    } else if (10 < level && level <= 20) {
      milliseconds = 400;
    } else if (20 < level && level <= 30) {
      milliseconds = 300;
    } else if (30 < level && level <= 40) {
      milliseconds = 200;
    } else if (40 < level && level <= 50) {
      milliseconds = 100;
    }
    await Future.delayed(Duration(milliseconds: milliseconds));
    tapX = double.parse(value.toStringAsFixed(1));
  }

  void hit() {
    state = PlayerState.dead;
    accelerationX = 0;
    final velocity = body.linearVelocity;
    body.linearVelocity = Vector2(velocity.x, -3);
  }

  void _setComponent(PositionComponent component) {
    if (accelerationX > 0) {
      if (!component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    } else {
      if (component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    }
    if (component == currentComponent) return;
    remove(currentComponent);
    currentComponent = component;
    add(component);
  }
}
