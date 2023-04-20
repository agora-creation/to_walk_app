import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/jump/game.dart';
import 'package:to_walk_app/games/resources.dart';

enum PlayerState {
  down,
  up,
  dead,
}

class PlayerObject extends BodyComponent<JumpGame> {
  static final size = Vector2(.8, .8);
  PlayerState state = PlayerState.down;
  late final SpriteComponent downComponent;
  late final SpriteAnimationComponent upComponent;
  late final SpriteComponent deadComponent;
  late Component currentComponent;
  final int level;
  bool isDead = false;

  PlayerObject({required this.level});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    downComponent = SpriteComponent(
      sprite: Resources.jumpPlayerDown,
      size: size,
      anchor: Anchor.center,
    );
    downComponent.flipHorizontally();
    upComponent = SpriteAnimationComponent(
      animation: Resources.jumpPlayerUp,
      size: size,
      anchor: Anchor.center,
    );
    upComponent.flipHorizontally();
    deadComponent = SpriteComponent(
      sprite: Resources.jumpPlayerDead,
      size: size,
      anchor: Anchor.center,
    );
    deadComponent.flipHorizontally();
    currentComponent = downComponent;
    add(currentComponent);
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(worldSize.x / 4, worldSize.y / 2),
      type: BodyType.dynamic,
    );
    final shape = CircleShape()..radius = .5;
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
    if (velocity.y > 0.1 && state != PlayerState.dead) {
      state = PlayerState.down;
    }
    if (state == PlayerState.down) {
      _setComponent(downComponent);
    } else if (state == PlayerState.up) {
      _setComponent2(upComponent);
    } else if (state == PlayerState.dead) {
      _setComponent(deadComponent);
    }
  }

  void jump() {
    if (!isDead) {
      state = PlayerState.up;
      double jump = (level * -1) * 0.5;
      final velocity = body.linearVelocity;
      body.linearVelocity = Vector2(velocity.x, jump);
    }
  }

  void dead() {
    state = PlayerState.dead;
    isDead = true;
  }

  void _setComponent(SpriteComponent component) {
    if (component == currentComponent) return;
    remove(component);
    currentComponent = component;
    add(component);
  }

  void _setComponent2(SpriteAnimationComponent component) {
    if (component == currentComponent) return;
    remove(component);
    currentComponent = component;
    add(component);
  }
}
