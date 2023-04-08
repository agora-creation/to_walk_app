import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/bullet.dart';
import 'package:to_walk_app/games/shooting/command.dart';
import 'package:to_walk_app/games/shooting/game.dart';
import 'package:to_walk_app/games/shooting/spaceship.dart';
import 'package:to_walk_app/games/shooting/utils.dart';

enum GameBonusEnum { ufoBonus }

abstract class GameBonus extends PositionComponent
    with GestureHitboxes, CollisionCallbacks, HasGameRef<ShootingGame> {
  static const double defaultSpeed = 100;
  static const int defaultDamage = 1;
  static const int defaultHealth = 1;
  static final defaultSize = Vector2.all(5);

  late Vector2 _velocity;
  late final double _speed;
  late final int? _health;
  late final int? _damage;
  late final Vector2 _resolutionMultiplier;
  late final int _triggerTimeSeconds;

  GameBonus(
    Vector2 position,
    Vector2 velocity,
    int triggerTimeSeconds,
    Vector2 resolutionMultiplier,
  )   : _velocity = velocity.normalized(),
        _speed = defaultSpeed,
        _health = defaultHealth,
        _damage = defaultDamage,
        _triggerTimeSeconds = triggerTimeSeconds,
        _resolutionMultiplier = resolutionMultiplier,
        super(
          size: defaultSize,
          position: position,
          anchor: Anchor.center,
        );

  GameBonus.fullInit(
    Vector2 position,
    Vector2 velocity,
    int triggerTimeSeconds,
    Vector2 resolutionMultiplier, {
    Vector2? size,
    double? speed,
    int? health,
    int? damage,
  })  : _velocity = velocity.normalized(),
        _speed = speed ?? defaultSpeed,
        _health = health ?? defaultHealth,
        _damage = damage ?? defaultDamage,
        _triggerTimeSeconds = triggerTimeSeconds,
        _resolutionMultiplier = resolutionMultiplier,
        super(
          size: size,
          position: position,
          anchor: Anchor.center,
        );

  int? get getDamage => _damage;
  int? get getHealth => _health;
  int? get getTriggerTime => _triggerTimeSeconds;

  void onCreate();

  void onDestroy();

  void onHit(CollisionCallbacks other);

  @override
  void update(double dt) {
    if (Utils.isPositionOutOfBounds(gameRef.size, position)) {
      GameBonusDestroyCommand(this).addToController(gameRef.controller);
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) {
      BulletCollisionCommand(other, this).addToController(gameRef.controller);
      GameBonusCollisionCommand(this, other)
          .addToController(gameRef.controller);
    }
    if (other is SpaceShip) {
      PlayerCollisionCommand(other, this).addToController(gameRef.controller);
    }
    super.onCollision(intersectionPoints, other);
  }
}

class UFOGameBonus extends GameBonus {
  static final Vector2 defaultSize = Vector2(100, 20);
  static final _paint = Paint()..color = Colors.white;

  UFOGameBonus(
    Vector2 position,
    Vector2 velocity,
    int triggerTimeSeconds,
    Vector2 resolutionMultiplier,
  ) : super.fullInit(
          position,
          velocity,
          triggerTimeSeconds,
          resolutionMultiplier,
          size: defaultSize,
          speed: GameBonus.defaultSpeed,
          health: GameBonus.defaultHealth,
          damage: GameBonus.defaultDamage,
        ) {
    add(RectangleHitbox());
  }

  UFOGameBonus.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 size,
    int triggerTimeSeconds,
    Vector2 resolutionMultiplier,
    double? speed,
    int? health,
    int? damage,
  ) : super.fullInit(
          position,
          velocity,
          triggerTimeSeconds,
          resolutionMultiplier,
          size: size,
          speed: speed,
          health: health,
          damage: damage,
        ) {
    add(RectangleHitbox());
  }

  @override
  Future onLoad() async {
    await super.onLoad();
    _velocity = (_velocity)..scaleTo(_speed);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(_velocity * dt);
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }
  @override
  void onHit(CollisionCallbacks other) {
    // TODO: implement onHit
  }
}

class GameBonusFactory {
  GameBonusFactory._();

  static GameBonus? create(GameBonusBuildContext context) {
    GameBonus? result;
    switch (context.gameBonusType) {
      case GameBonusEnum.ufoBonus:
        if (context.size != GameBonusBuildContext.defaultSize) {
          result = UFOGameBonus.fullInit(
            context.position,
            context.velocity,
            context.size,
            context.timeTriggerSeconds,
            context.multiplier,
            context.speed,
            context.health,
            context.damage,
          );
        } else {
          result = UFOGameBonus(
            context.position,
            context.velocity,
            context.timeTriggerSeconds,
            context.multiplier,
          );
        }
        break;
    }
    return result;
  }
}

class GameBonusBuildContext {
  static const double defaultSpeed = 0;
  static const int defaultHealth = 1;
  static const int defaultDamage = 1;
  static final Vector2 defaultVelocity = Vector2.zero();
  static final Vector2 defaultPosition = Vector2(-1, -1);
  static final Vector2 defaultSize = Vector2.zero();
  static final Vector2 defaultMultiplier = Vector2.all(1);
  static final GameBonusEnum defaultGameBonusType = GameBonusEnum.values[0];
  static const int defaultTimeTriggerSeconds = 0;

  double speed = defaultSpeed;
  Vector2 velocity = defaultVelocity;
  Vector2 position = defaultPosition;
  Vector2 size = defaultSize;
  int health = defaultHealth;
  int damage = defaultDamage;
  Vector2 multiplier = defaultMultiplier;
  GameBonusEnum gameBonusType = defaultGameBonusType;
  int timeTriggerSeconds = defaultTimeTriggerSeconds;

  GameBonusBuildContext();

  static GameBonusEnum gameBonusFromString(String value) {
    return GameBonusEnum.values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == value.toUpperCase(),
    );
  }
}
