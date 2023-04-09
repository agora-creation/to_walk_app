import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/command.dart';
import 'package:to_walk_app/games/shooting/game.dart';
import 'package:to_walk_app/games/shooting/utils.dart';

//Bullet由来の名前を列挙した単純な列挙型を保持します
//Bulletの種類を追加するには、ここに追加する
//BulletFactoryを使って、Bulletを簡単に作ることができます
//以下手順
//1.新しいBulletの実装では、Bulletクラスを拡張する
//2.新しい列挙項目追加する
//3.BulletFactoryに新しいswitch-caseを追加して、Bulletを作成する
//4.列挙項目が提供された場合、新しいBulletインスタンスを作成する
enum BulletEnum { slowBullet, fastBullet }

//BulletクラスはPositionComponentなので、角度・位置を取得します
//これは抽象クラスで、Bulletを使うためには拡張する必要があります
abstract class Bullet extends PositionComponent
    with HasGameRef<ShootingGame>, GestureHitboxes, CollisionCallbacks {
  static const double defaultSpeed = 100;
  static const int defaultAttack = 1;
  static const int defaultHp = 1;
  static final Vector2 defaultSize = Vector2.all(1);

  //Bulletの速度Vector
  late Vector2 _velocity;
  //Bulletの速度
  late double _speed;
  //Bulletの体力
  late int? _hp;
  //Bulletの攻撃力
  late int? _attack;

  Bullet(
    Vector2 position,
    Vector2 velocity,
  )   : _velocity = velocity.normalized(),
        _speed = defaultSpeed,
        _hp = defaultHp,
        _attack = defaultAttack,
        super(
          size: defaultSize,
          position: position,
          anchor: Anchor.center,
        );

  Bullet.fullInit(
    Vector2 position,
    Vector2 velocity, {
    Vector2? size,
    double? speed,
    int? hp,
    int? attack,
  })  : _velocity = velocity.normalized(),
        _speed = speed ?? defaultSpeed,
        _hp = hp ?? defaultHp,
        _attack = attack ?? defaultAttack,
        super(
          size: size,
          position: position,
          anchor: Anchor.center,
        );

  Bullet.classname();

  int? get getAttack => _attack;

  int? get getHp => _hp;

  @override
  void update(double dt) {
    _onOutOfBounds(position);
  }

  void onCreate() {
    //衝突検出の精度を上げるために、ヒットボックスを作る。
    //弾丸の場合、約4倍の大きさになります。
    add(RectangleHitbox(size: Vector2.all(2)));
  }

  void onDestroy();

  void onHit(CollisionCallbacks other);

  void _onOutOfBounds(Vector2 position) {
    if (Utils.isPositionOutOfBounds(gameRef.size, position)) {
      BulletDestroyCommand(this).addToController(gameRef.controller);
    }
  }
}

class FastBullet extends Bullet {
  static const double defaultSpeed = 175;
  static final Vector2 defaultSize = Vector2.all(2);
  static final _paint = Paint()..color = Colors.green;

  FastBullet(
    Vector2 position,
    Vector2 velocity,
  ) : super.fullInit(
          position,
          velocity,
          size: defaultSize,
          speed: defaultSpeed,
          hp: Bullet.defaultHp,
          attack: Bullet.defaultAttack,
        );

  FastBullet.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2? size,
    double? speed,
    int? hp,
    int? attack,
  ) : super.fullInit(
          position,
          velocity,
          size: size,
          speed: speed,
          hp: hp,
          attack: attack,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _velocity = (_velocity)..scaleTo(_speed);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
    renderDebugMode(canvas);
  }

  @override
  void update(double dt) {
    position.add(_velocity * dt);
    super.update(dt);
  }

  @override
  void onCreate() {
    super.onCreate();
    print("FastBullet onCreate called");
  }

  @override
  void onDestroy() {
    print("FastBullet onDestroy called");
  }

  @override
  void onHit(CollisionCallbacks other) {
    print("FastBullet onHit called");
  }
}

class SlowBullet extends Bullet {
  static const double defaultSpeed = 50;
  static final Vector2 defaultSize = Vector2.all(4);
  static final _paint = Paint()..color = Colors.red;

  SlowBullet(
    Vector2 position,
    Vector2 velocity,
  ) : super.fullInit(
          position,
          velocity,
          size: defaultSize,
          speed: defaultSpeed,
          hp: Bullet.defaultHp,
          attack: Bullet.defaultAttack,
        );

  SlowBullet.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2? size,
    double? speed,
    int? hp,
    int? attack,
  ) : super.fullInit(
          position,
          velocity,
          size: size,
          speed: speed,
          hp: hp,
          attack: attack,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _velocity = (_velocity)..scaleTo(_speed);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, _paint);
    renderDebugMode(canvas);
  }

  @override
  void update(double dt) {
    position.add(_velocity * dt);
    super.update(dt);
  }

  @override
  void onCreate() {
    super.onCreate();
    print("SlowBullet onCreate called");
  }

  @override
  void onDestroy() {
    print("SlowBullet onDestroy called");
  }

  @override
  void onHit(CollisionCallbacks other) {
    print("SlowBullet onHit called");
  }
}

class BulletFactory {
  BulletFactory._();

  static Bullet create(BulletBuildContext context) {
    Bullet result;
    switch (context.bulletType) {
      case BulletEnum.slowBullet:
        if (context.speed != BulletBuildContext.defaultSpeed) {
          result = SlowBullet.fullInit(
            context.position,
            context.velocity,
            context.size,
            context.speed,
            context.hp,
            context.attack,
          );
        } else {
          result = SlowBullet(context.position, context.velocity);
        }
        break;
      case BulletEnum.fastBullet:
        if (context.speed != BulletBuildContext.defaultSpeed) {
          result = FastBullet.fullInit(
            context.position,
            context.velocity,
            context.size,
            context.speed,
            context.hp,
            context.attack,
          );
        } else {
          result = FastBullet(context.position, context.velocity);
        }
        break;
    }
    result.onCreate();
    return result;
  }
}

class BulletBuildContext {
  static const double defaultSpeed = 0;
  static const int defaultHp = 1;
  static const int defaultAttack = 1;
  static final Vector2 defaultVelocity = Vector2.zero();
  static final Vector2 defaultPosition = Vector2(-1, -1);
  static final Vector2 defaultSize = Vector2.zero();
  static final BulletEnum defaultBulletType = BulletEnum.values[0];

  double speed = defaultSpeed;
  Vector2 velocity = defaultVelocity;
  Vector2 position = defaultPosition;
  Vector2 size = defaultSize;
  int hp = defaultHp;
  int attack = defaultAttack;
  BulletEnum bulletType = defaultBulletType;

  BulletBuildContext();
}
