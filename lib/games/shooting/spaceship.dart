import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/bullet.dart';
import 'package:to_walk_app/games/shooting/game.dart';
import 'package:to_walk_app/games/shooting/utils.dart';

enum SpaceShipEnum { simpleSpaceShip }

abstract class SpaceShip extends SpriteComponent
    with HasGameRef<ShootingGame>, GestureHitboxes, CollisionCallbacks {
  static const double defaultSpeed = 100;
  static const double defaultMaxSpeed = 300;
  static const int defaultDamage = 1;
  static const int defaultHealth = 1;
  static final Vector2 defaultSize = Vector2.all(5);

  late Vector2 _velocity;
  late double _speed;
  late int? _health;
  late int? _damage;
  late final Vector2 _resolutionMultiplier;
  late final double _maxSpeed = defaultMaxSpeed;
  final BulletEnum _currentBulletType = BulletEnum.fastBullet;
  //SpaceShipの先端の位置にある1pxの回転した鼻の位置を計算するために使用
  //弾がどこから撃たれているのか位置がわかるように
  static final _paint = Paint()..color = Colors.transparent;
  //射撃用銃口px
  final RectangleComponent _muzzleComponent = RectangleComponent(
    size: Vector2(1, 1),
    paint: _paint,
  );
  late final JoystickComponent _joystick;

  SpaceShip(
    Vector2 resolutionMultiplier,
    JoystickComponent joystick,
  )   : _health = defaultHealth,
        _damage = defaultDamage,
        _resolutionMultiplier = resolutionMultiplier,
        _joystick = joystick,
        super(
          size: defaultSize,
          anchor: Anchor.center,
        );

  SpaceShip.fullInit(
    Vector2 resolutionMultiplier,
    JoystickComponent joystick, {
    Vector2? size,
    double? speed,
    int? health,
    int? damage,
  })  : _resolutionMultiplier = resolutionMultiplier,
        _joystick = joystick,
        _speed = speed ?? defaultSpeed,
        _health = health ?? defaultHealth,
        _damage = damage ?? defaultDamage,
        super(
          size: size,
          anchor: Anchor.center,
        );

  BulletEnum get getBulletType => _currentBulletType;
  RectangleComponent get getMuzzleComponent => _muzzleComponent;

  void onCreate() {
    anchor = Anchor.center;
    size = Vector2.all(60);
    add(RectangleHitbox());
  }

  void onDestroy();

  void onHit(CollisionCallbacks other);

  Vector2 getNextPosition() {
    return Utils.wrapPosition(gameRef.size, position);
  }
}

class SimpleSpaceShip extends SpaceShip {
  static const double defaultSpeed = 300;
  static final Vector2 defaultSize = Vector2.all(2);
  static final _paint = Paint()..color = Colors.green;

  SimpleSpaceShip(
    Vector2 resolutionMultiplier,
    JoystickComponent joystick,
  ) : super.fullInit(
          resolutionMultiplier,
          joystick,
          size: defaultSize,
          speed: defaultSpeed,
          health: SpaceShip.defaultHealth,
          damage: SpaceShip.defaultDamage,
        );

  SimpleSpaceShip.fullInit(
    Vector2 resolutionMultiplier,
    JoystickComponent joystick,
    Vector2? size,
    double? speed,
    int? health,
    int? damage,
  ) : super.fullInit(
          resolutionMultiplier,
          joystick,
          size: size,
          speed: speed,
          health: health,
          damage: damage,
        );

  @override
  Future onLoad() async {
    await super.onLoad();
    size = Utils.vector2Multiply(
      size,
      gameRef.controller.getResolutionMultiplier,
    );
    size.y = size.x;
    sprite = await gameRef.loadSprite('asteroids_ship.png');
    position = gameRef.size / 2;
    _muzzleComponent.position.x = size.x / 2;
    _muzzleComponent.position.y = size.y / 10;
    add(_muzzleComponent);
  }

  @override
  void update(double dt) {
    if (!_joystick.delta.isZero()) {
      getNextPosition().add(_joystick.relativeDelta * _maxSpeed * dt);
      angle = _joystick.delta.screenAngle();
    }
    super.update(dt);
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    super.onCreate();
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

class SpaceShipFactory {
  SpaceShipFactory._();

  static SpaceShip create(PlayerBuildContext context) {
    SpaceShip result;
    switch (context.spaceShipType) {
      case SpaceShipEnum.simpleSpaceShip:
        if (context.speed != PlayerBuildContext.defaultSpeed) {
          result = SimpleSpaceShip.fullInit(
            context.multiplier,
            context.joystick,
            context.size,
            context.speed,
            context.health,
            context.damage,
          );
        } else {
          result = SimpleSpaceShip(
            context.position,
            context.joystick,
          );
        }
        break;
    }
    result.onCreate();
    return result;
  }
}

class PlayerBuildContext {
  static const double defaultSpeed = 0;
  static const int defaultHealth = 1;
  static const int defaultDamage = 1;
  static final Vector2 defaultVelocity = Vector2.zero();
  static final Vector2 defaultPosition = Vector2(-1, -1);
  static final Vector2 defaultSize = Vector2.zero();
  static final SpaceShipEnum defaultSpaceShipType = SpaceShipEnum.values[0];
  static final Vector2 defaultMultiplier = Vector2.all(1);

  static SpaceShipEnum spaceShipFromString(String value) {
    return SpaceShipEnum.values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == value.toUpperCase(),
    );
  }

  double speed = defaultSpeed;
  Vector2 velocity = defaultVelocity;
  Vector2 position = defaultPosition;
  Vector2 size = defaultSize;
  int health = defaultHealth;
  int damage = defaultDamage;
  Vector2 multiplier = defaultMultiplier;
  SpaceShipEnum spaceShipType = defaultSpaceShipType;
  late JoystickComponent joystick;

  PlayerBuildContext();
}
