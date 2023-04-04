import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/bullet.dart';
import 'package:to_walk_app/games/shooting/game.dart';
import 'package:to_walk_app/games/shooting/spaceship.dart';
import 'package:to_walk_app/games/shooting/utils.dart';

//小惑星の種類
enum AsteroidEnum { largeAsteroid, mediumAsteroid, smallAsteroid }

//小惑星の抽象クラス
abstract class Asteroid extends PositionComponent
    with GestureHitboxes, CollisionCallbacks, HasGameRef<ShootingGame> {
  static const double defaultSpeed = 100;
  static const int defaultDamage = 1;
  static const int defaultHealth = 1;
  static final defaultSize = Vector2.all(5);

  late Vector2 _velocity;
  late double _speed;
  late int? _health;
  late int? _damage;
  late final Vector2 _resolutionMultiplier;

  //デフォルトのコンストラクタ
  Asteroid(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
  )   : _velocity = velocity.normalized(),
        _health = defaultHealth,
        _damage = defaultDamage,
        _resolutionMultiplier = resolutionMultiplier,
        super(
          size: defaultSize,
          position: position,
          anchor: Anchor.center,
        );

  //設定コンストラクタ
  Asteroid.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier, {
    Vector2? size,
    double? speed,
    int? health,
    int? damage,
  })  : _velocity = velocity.normalized(),
        _health = health ?? defaultHealth,
        _damage = damage ?? defaultDamage,
        _resolutionMultiplier = resolutionMultiplier,
        _speed = speed ?? defaultSpeed,
        super(
          size: defaultSize,
          position: position,
          anchor: Anchor.center,
        );

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Bullet) {}
    if (other is Spaceship) {}
  }

  int? get getDamage => _damage;
  int? get getHealth => _health;
  Vector2 get getVelocity => _velocity;

  //小惑星が作成された時
  void onCreate() {}

  //小惑星が破壊された時
  void onDestroy() {}

  //小惑星が衝突した時
  void onHit(CollisionCallbacks other) {}

  //小惑星が分割可能かチェック
  bool canBeSplit() => false;

  //小惑星を分割したリスト
  //無ければ空リスト
  //小惑星が衝突して分割した後の値
  List<AsteroidEnum> getSplitAsteroids() {
    return List.empty();
  }

  Vector2 getNextPosition() {
    return Utils.wrapPosition(gameRef.size, position);
  }
}

//小さい小惑星
//シンプルな緑の円
//速度は150、ダメージは1、体力は1
class SmallAsteroid extends Asteroid {
  static const double defaultSpeed = 150;
  static final Vector2 defaultSize = Vector2.all(16);
  static final _paint = Paint()..color = Colors.green;

  //デフォルトのコンストラクタ
  SmallAsteroid(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
  ) : super.fullInit(
          position,
          velocity,
          resolutionMultiplier,
          speed: defaultSpeed,
          health: Asteroid.defaultHealth,
          damage: Asteroid.defaultDamage,
          size: defaultSize,
        );

  //設定コンストラクタ
  SmallAsteroid.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
    Vector2? size,
    double? speed,
    int? health,
    int? damage,
  ) : super.fullInit(
          position,
          velocity,
          resolutionMultiplier,
          size: defaultSize,
          speed: speed ?? defaultSpeed,
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
    final localCenter = (scaledSize / 2).toOffset();
    canvas.drawCircle(localCenter, size.x, _paint);
    renderDebugMode(canvas);
  }

  @override
  void update(double dt) {
    getNextPosition().add(_velocity * dt);
    super.update(dt);
  }

  @override
  void onCreate() {
    //小惑星の作成を上書きする
    //倍率に応じてサイズ調整
    //JSONファイルではなくプログラム内で
    size = Utils.vector2Multiply(size, _resolutionMultiplier);
    size.y = size.x;
    add(CircleHitbox(radius: 2));
    super.onCreate();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    super.onDestroy();
  }

  @override
  void onHit(CollisionCallbacks other) {
    // TODO: implement onHit
    super.onHit(other);
  }
}

//中くらいの小惑星
//シンプルな青い円
//速度は150、ダメージは1、体力は1
class MediumAsteroid extends Asteroid {
  static const double defaultSpeed = 100;
  static final Vector2 defaultSize = Vector2.all(32);
  static final _paint = Paint()..color = Colors.blue;

  //デフォルトのコンストラクタ
  MediumAsteroid(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
  ) : super.fullInit(
          position,
          velocity,
          resolutionMultiplier,
          speed: defaultSpeed,
          health: Asteroid.defaultHealth,
          damage: Asteroid.defaultDamage,
          size: defaultSize,
        );

  //設定コンストラクタ
  MediumAsteroid.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
    Vector2? size,
    double? speed,
    int? health,
    int? damage,
  ) : super.fullInit(
          position,
          velocity,
          resolutionMultiplier,
          size: size,
          speed: speed ?? defaultSpeed,
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
    final localCenter = (scaledSize / 2).toOffset();
    canvas.drawCircle(localCenter, size.x, _paint);
    renderDebugMode(canvas);
  }

  @override
  void update(double dt) {
    getNextPosition().add(_velocity * dt);
    super.update(dt);
  }

  @override
  void onCreate() {
    //小惑星の作成を上書きする
    //倍率に応じてサイズ調整
    //JSONファイルではなくプログラム内で
    size = Utils.vector2Multiply(size, _resolutionMultiplier);
    size.y = size.x;
    add(CircleHitbox(radius: 2));
    super.onCreate();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    super.onDestroy();
  }

  @override
  void onHit(CollisionCallbacks other) {
    // TODO: implement onHit
    super.onHit(other);
  }

  //この小惑星を小さい小惑星に分割
  @override
  List<AsteroidEnum> getSplitAsteroids() {
    return [AsteroidEnum.smallAsteroid, AsteroidEnum.smallAsteroid];
  }
}

//大きい小惑星
//シンプルな赤い円
//速度は150、ダメージは1、体力は1
class LargeAsteroid extends Asteroid {
  static const double defaultSpeed = 50;
  static final Vector2 defaultSize = Vector2.all(64);
  static final _paint = Paint()..color = Colors.red;

  //デフォルトのコンストラクタ
  LargeAsteroid(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
  ) : super.fullInit(
          position,
          velocity,
          resolutionMultiplier,
          speed: defaultSpeed,
          health: Asteroid.defaultHealth,
          damage: Asteroid.defaultDamage,
          size: defaultSize,
        );

  //設定コンストラクタ
  LargeAsteroid.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
    Vector2? size,
    double? speed,
    int? health,
    int? damage,
  ) : super.fullInit(
          position,
          velocity,
          resolutionMultiplier,
          size: size,
          speed: speed ?? defaultSpeed,
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
    final localCenter = (scaledSize / 2).toOffset();
    canvas.drawCircle(localCenter, size.x, _paint);
    renderDebugMode(canvas);
  }

  @override
  void update(double dt) {
    getNextPosition().add(_velocity * dt);
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
    super.onDestroy();
  }

  @override
  void onHit(CollisionCallbacks other) {
    // TODO: implement onHit
    super.onHit(other);
  }

  //この小惑星を中くらい小惑星に分割
  @override
  List<AsteroidEnum> getSplitAsteroids() {
    return [AsteroidEnum.mediumAsteroid, AsteroidEnum.mediumAsteroid];
  }
}

//小惑星を作成する工場
class AsteroidFactory {
  //プライベートクラスにする
  AsteroidFactory._();

  //作成メソッド
  static Asteroid create(AsteroidBuildContext context) {
    Asteroid result;
    switch (context.asteroidType) {
      case AsteroidEnum.smallAsteroid:
        if (context.size != AsteroidBuildContext.defaultSize) {
          result = SmallAsteroid.fullInit(
            context.position,
            context.velocity,
            context.multiplier,
            context.size,
            context.speed,
            context.health,
            context.damage,
          );
        } else {
          result = SmallAsteroid(
            context.position,
            context.velocity,
            context.multiplier,
          );
        }
        break;
      case AsteroidEnum.mediumAsteroid:
        if (context.size != AsteroidBuildContext.defaultSize) {
          result = MediumAsteroid.fullInit(
            context.position,
            context.velocity,
            context.multiplier,
            context.size,
            context.speed,
            context.health,
            context.damage,
          );
        } else {
          result = MediumAsteroid(
            context.position,
            context.velocity,
            context.multiplier,
          );
        }
        break;
      case AsteroidEnum.largeAsteroid:
        if (context.size != AsteroidBuildContext.defaultSize) {
          result = LargeAsteroid.fullInit(
            context.position,
            context.velocity,
            context.multiplier,
            context.size,
            context.speed,
            context.health,
            context.damage,
          );
        } else {
          result = LargeAsteroid(
            context.position,
            context.velocity,
            context.multiplier,
          );
        }
        break;
    }
    //インスタンスを返す前に、必要な動作を呼び出す
    result.onCreate();
    return result;
  }
}

//新規作成時のデータホルダー
class AsteroidBuildContext {
  static const double defaultSpeed = 0;
  static const int defaultHealth = 1;
  static const int defaultDamage = 1;
  static final Vector2 defaultVelocity = Vector2.zero();
  static final Vector2 defaultPosition = Vector2.all(-1);
  static final Vector2 defaultSize = Vector2.zero();
  static final AsteroidEnum defaultAsteroidType = AsteroidEnum.values[0];
  static final Vector2 defaultMultiplier = Vector2.all(1);

  static AsteroidEnum asteroidFromString(String value) {
    return AsteroidEnum.values.firstWhere(
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
  AsteroidEnum asteroidType = defaultAsteroidType;

  AsteroidBuildContext();
}
