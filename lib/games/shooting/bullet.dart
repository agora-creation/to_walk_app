import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

abstract class Bullet extends PositionComponent {
  static const double defaultSpeed = 100;
  static const int defaultDamage = 1;
  static const int defaultHealth = 1;

  late Vector2 _velocity;
  late double _speed;
  late int? _health;
  late int? _damage;

  Bullet(
    Vector2 position,
    Vector2 velocity,
    Vector2 size,
  )   : _velocity = velocity.normalized(),
        _speed = defaultSpeed,
        _health = defaultHealth,
        _damage = defaultDamage,
        super(
          size: size,
          position: position,
          anchor: Anchor.center,
        );

  Bullet.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 size, {
    double? speed,
    int? health,
    int? damage,
  })  : _velocity = velocity.normalized(),
        _speed = speed ?? defaultSpeed,
        _health = health ?? defaultHealth,
        _damage = damage ?? defaultDamage,
        super(
          size: size,
          position: position,
          anchor: Anchor.center,
        );

  Bullet.classname();

  int? get getDamage => _damage;
  int? get getHealth => _health;

  void onCreate();

  void onDestroy();

  void onHit(CollisionCallbacks other);
}

class FastBullet extends Bullet {
  static final _paint = Paint()..color = Colors.green;

  FastBullet(
    Vector2 position,
    Vector2 velocity,
    Vector2 size,
  ) : super(
          position,
          velocity,
          size,
        );

  FastBullet.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 size, {
    double? speed,
    int? health,
    int? damage,
  }) : super.fullInit(
          position,
          velocity,
          size,
          speed: speed,
          health: health,
          damage: damage,
        );

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

enum BulletEnum { slowBullet, fastBullet }

class SlowBullet extends Bullet {
  static final _paint = Paint()..color = Colors.red;

  SlowBullet(
    Vector2 position,
    Vector2 velocity,
    Vector2 size,
  ) : super(
          position,
          velocity,
          size,
        );

  SlowBullet.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 size, {
    double? speed,
    int? health,
    int? damage,
  }) : super.fullInit(
          position,
          velocity,
          size,
          speed: speed,
          health: health,
          damage: damage,
        );

  @override
  Future onLoad() async {
    await super.onLoad();
    _velocity = (_velocity)..scaleTo(_speed);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset(size.x / 2, size.y / 1), size.x / 2, _paint);
  }

  @override
  void update(double dt) {
    position.add(_velocity * dt);
    super.update(dt);
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

class BulletFactory {
  BulletFactory._();

  static Bullet create(BulletEnum choice, BulletBuildContext context) {
    Bullet result;
    switch (choice) {
      case BulletEnum.slowBullet:
        if (context.speed != BulletBuildContext.defaultSpeed) {
          result = SlowBullet.fullInit(
            context.position,
            context.velocity,
            context.size,
            speed: context.speed,
            health: context.health,
            damage: context.damage,
          );
        } else {
          result = SlowBullet.fullInit(
            context.position,
            context.velocity,
            context.size,
          );
        }
        break;
      case BulletEnum.fastBullet:
        if (context.speed != BulletBuildContext.defaultSpeed) {
          result = FastBullet.fullInit(
            context.position,
            context.velocity,
            context.size,
            speed: context.speed,
            health: context.health,
            damage: context.damage,
          );
        } else {
          result = FastBullet.fullInit(
            context.position,
            context.velocity,
            context.size,
          );
        }
        break;
    }
    result.onCreate();
    return result;
  }
}

class BulletBuildContext {
  static const double defaultSpeed = 0;
  static const int defaultHealth = 1;
  static const int defaultDamage = 1;
  static final Vector2 defaultVelocity = Vector2.zero();
  static final Vector2 defaultPosition = Vector2(-1, -1);
  static final Vector2 defaultSize = Vector2.zero();

  double speed = defaultSpeed;
  Vector2 velocity = defaultVelocity;
  Vector2 position = defaultPosition;
  Vector2 size = defaultSize;
  int health = defaultHealth;
  int damage = defaultDamage;

  BulletBuildContext();
}
