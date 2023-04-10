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
  static const int defaultAttack = 1;
  static const int defaultHp = 1;
  static final defaultSize = Vector2.all(5.0);

  //GameBonusの速度Vector
  late Vector2 _velocity;
  //GameBonusの速度
  late final double _speed;
  //GameBonusの体力
  late final int? _hp;
  //GameBonusの攻撃力
  late final int? _attack;
  //解像度倍率
  late final Vector2 _resolutionMultiplier;
  //発火するまでの秒数
  late final int _triggerTimeSeconds;

  GameBonus(
    Vector2 position,
    Vector2 velocity,
    int triggerTimeSeconds,
    Vector2 resolutionMultiplier,
  )   : _velocity = velocity.normalized(),
        _speed = defaultSpeed,
        _hp = defaultHp,
        _attack = defaultAttack,
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
    int? hp,
    int? attack,
  })  : _velocity = velocity.normalized(),
        _speed = speed ?? defaultSpeed,
        _hp = hp ?? defaultHp,
        _attack = attack ?? defaultAttack,
        _triggerTimeSeconds = triggerTimeSeconds,
        _resolutionMultiplier = resolutionMultiplier,
        super(
          size: size,
          position: position,
          anchor: Anchor.center,
        );

  int? get getAttack => _attack;
  int? get getHp => _hp;
  int? get getTriggerTime => _triggerTimeSeconds;

  void onCreate();

  void onDestroy();

  void onHit(CollisionCallbacks other);

  @override
  void update(double dt) {
    _onOutOfBounds(position);
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

  void _onOutOfBounds(Vector2 position) {
    if (Utils.isPositionOutOfBounds(gameRef.size, position)) {
      GameBonusDestroyCommand(this).addToController(gameRef.controller);
    }
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
          hp: GameBonus.defaultHp,
          attack: GameBonus.defaultAttack,
        ) {
    add(RectangleHitbox());
  }

  UFOGameBonus.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 size,
    int triggerTimeSeconds,
    resolutionMultiplier,
    double? speed,
    int? hp,
    int? attack,
  ) : super.fullInit(
          position,
          velocity,
          triggerTimeSeconds,
          resolutionMultiplier,
          size: size,
          speed: speed,
          hp: hp,
          attack: attack,
        ) {
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
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
    debugPrint("UFOGameBonus onCreate called");
  }

  @override
  void onDestroy() {
    debugPrint("UFOGameBonus onDestroy called");
  }

  @override
  void onHit(CollisionCallbacks other) {
    debugPrint("UFOGameBonus onHit called");
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
            context.hp,
            context.attack,
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
  static const int defaultHp = 1;
  static const int defaultAttack = 1;
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
  int hp = defaultHp;
  int attack = defaultAttack;
  Vector2 multiplier = defaultMultiplier;
  GameBonusEnum gameBonusType = defaultGameBonusType;
  int timeTriggerSeconds = defaultTimeTriggerSeconds;

  GameBonusBuildContext();

  static GameBonusEnum gameBonusFromString(String value) {
    debugPrint('${GameBonusEnum.values}');
    return GameBonusEnum.values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == value.toUpperCase(),
    );
  }

  @override
  String toString() {
    return 'name: $gameBonusType , speed: $speed , position: $position , velocity: $velocity, trigger.time: $timeTriggerSeconds , multiplier: $multiplier';
  }
}
