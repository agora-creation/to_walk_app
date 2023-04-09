import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/bullet.dart';
import 'package:to_walk_app/games/shooting/command.dart';
import 'package:to_walk_app/games/shooting/game.dart';
import 'package:to_walk_app/games/shooting/spaceship.dart';
import 'package:to_walk_app/games/shooting/utils.dart';

//Asteroid由来の名前を列挙した単純な列挙型を保持します
//Asteroidの種類を追加するには、ここに追加する
//AsteroidFactoryを使って、Asteroidを簡単に作ることができます
//以下手順
//1.新しいAsteroidの実装では、Asteroidクラスを拡張する
//2.新しい列挙項目追加する
//3.AsteroidFactoryに新しいswitch-caseを追加して、Asteroidを作成する
//4.列挙項目が提供された場合、新しいAsteroidインスタンスを作成する
enum AsteroidEnum { largeAsteroid, mediumAsteroid, smallAsteroid }

//AsteroidクラスはPositionComponentなので、角度・位置を取得します
//これは抽象クラスで、Asteroidを使うためには拡張する必要があります
abstract class Asteroid extends PositionComponent
    with GestureHitboxes, CollisionCallbacks, HasGameRef<ShootingGame> {
  static const double defaultSpeed = 100;
  static const int defaultAttack = 1;
  static const int defaultHp = 1;
  static final defaultSize = Vector2.all(5);

  //Asteroidの速度Vector
  late Vector2 _velocity;
  //Asteroidの速度
  late double _speed;
  //Asteroidの体力
  late int? _hp;
  //Asteroidの攻撃力
  late int? _attack;
  //解像度乗算機
  late final Vector2 _resolutionMultiplier;

  //初期値を持つコンストラクタ
  Asteroid(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
  )   : _velocity = velocity.normalized(),
        _hp = defaultHp,
        _attack = defaultAttack,
        _resolutionMultiplier = resolutionMultiplier,
        super(
          size: defaultSize,
          position: position,
          anchor: Anchor.center,
        );

  //任意値を持つコンストラクタ
  Asteroid.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier, {
    Vector2? size,
    double? speed,
    int? hp,
    int? attack,
  })  : _resolutionMultiplier = resolutionMultiplier,
        _velocity = velocity.normalized(),
        _speed = speed ?? defaultSpeed,
        _hp = hp ?? defaultHp,
        _attack = attack ?? defaultAttack,
        super(
          size: size,
          position: position,
          anchor: Anchor.center,
        );

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) {
      BulletCollisionCommand(other, this).addToController(gameRef.controller);
      AsteroidCollisionCommand(this, other).addToController(gameRef.controller);
      UpdateScoreboardScoreCommand(gameRef.controller.getScoreBoard)
          .addToController(gameRef.controller);
    }
    if (other is SpaceShip) {
      PlayerCollisionCommand(other, this).addToController(gameRef.controller);
    }
    super.onCollision(intersectionPoints, other);
  }

  int? get getAttack => _attack;
  int? get getHp => _hp;
  Vector2 get getVelocity => _velocity;

  //Asteroidが作成された時
  void onCreate() {
    //サイズ・位置・解像度倍率を適用する
    size = Utils.vector2Multiply(size, _resolutionMultiplier);
    size.y = size.x;
    position = Utils.vector2Multiply(position, _resolutionMultiplier);
    add(CircleHitbox(radius: 2));
  }

  //Asteroidが破壊された時
  void onDestroy();

  //Asteroidが衝突した時
  void onHit(CollisionCallbacks other);

  //Asteroidが分割可能かチェックする
  bool canBeSplit() {
    return getSplitAsteroids().isNotEmpty;
  }

  //このAsteroidを分割するAsteroidTypeのリストを返す必要があります
  //無ければ空のリスト
  List<AsteroidEnum> getSplitAsteroids() {
    return List.empty();
  }

  Vector2 getNextPosition() {
    return Utils.wrapPosition(gameRef.size, position);
  }

  @override
  String toString() {
    return 'speed: $_speed , position: $position , velocity: $_velocity, multiplier: $_resolutionMultiplier';
  }
}

class SmallAsteroid extends Asteroid {
  static const double defaultSpeed = 150;
  static final Vector2 defaultSize = Vector2(16.0, 16.0);
  static final _paint = Paint()..color = Colors.green;

  SmallAsteroid(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
  ) : super.fullInit(
          position,
          velocity,
          resolutionMultiplier,
          speed: defaultSpeed,
          hp: Asteroid.defaultHp,
          attack: Asteroid.defaultAttack,
          size: defaultSize,
        );

  SmallAsteroid.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
    Vector2? size,
    double? speed,
    int? hp,
    int? attack,
  ) : super.fullInit(
          position,
          velocity,
          resolutionMultiplier,
          size: size,
          speed: speed ?? defaultSpeed,
          hp: hp,
          attack: attack,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //_velocityは単位Vectorなので、実際の速度を考慮する必要があります
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
  }

  @override
  void onCreate() {
    //Asteroidの作成を完全に上書きする
    //解像度倍率に応じてサイズを調整しますが、その際、
    //この位置は初期化されているため、提供された実際の位置を利用する
    //サイズ・位置・解像度倍率を適用する
    size = Utils.vector2Multiply(size, _resolutionMultiplier);
    size.y = size.x;
    add(CircleHitbox(radius: 2));
  }

  @override
  void onDestroy() {
    debugPrint("SmallAsteroid onDestroy called");
  }

  @override
  void onHit(CollisionCallbacks other) {
    debugPrint("SmallAsteroid onHit called");
  }
}

class MediumAsteroid extends Asteroid {
  static const double defaultSpeed = 100;
  static final Vector2 defaultSize = Vector2.all(32);
  static final _paint = Paint()..color = Colors.blue;

  MediumAsteroid(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
  ) : super.fullInit(
          position,
          velocity,
          resolutionMultiplier,
          speed: defaultSpeed,
          hp: Asteroid.defaultHp,
          attack: Asteroid.defaultAttack,
          size: defaultSize,
        );

  MediumAsteroid.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
    Vector2? size,
    double? speed,
    int? hp,
    int? attack,
  ) : super.fullInit(
          position,
          velocity,
          resolutionMultiplier,
          size: size,
          speed: speed ?? defaultSpeed,
          hp: hp,
          attack: attack,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //_velocityは単位Vectorなので、実際の速度を考慮する必要があります
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
  }

  @override
  void onCreate() {
    //Asteroidの作成を完全に上書きする
    //解像度倍率に応じてサイズを調整しますが、その際、
    //この位置は初期化されているため、提供された実際の位置を利用する
    //サイズ・位置・解像度倍率を適用する
    size = Utils.vector2Multiply(size, _resolutionMultiplier);
    size.y = size.x;
    add(CircleHitbox(radius: 2));
  }

  @override
  void onDestroy() {
    debugPrint("MediumAsteroid onDestroy called");
  }

  @override
  void onHit(CollisionCallbacks other) {
    debugPrint("MediumAsteroid onHit called");
  }

  @override
  List<AsteroidEnum> getSplitAsteroids() {
    return [AsteroidEnum.smallAsteroid, AsteroidEnum.smallAsteroid];
  }
}

class LargeAsteroid extends Asteroid {
  static const double defaultSpeed = 50;
  static final Vector2 defaultSize = Vector2.all(64);
  static final _paint = Paint()..color = Colors.red;

  LargeAsteroid(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
  ) : super.fullInit(
          position,
          velocity,
          resolutionMultiplier,
          speed: defaultSpeed,
          hp: Asteroid.defaultHp,
          attack: Asteroid.defaultAttack,
          size: defaultSize,
        );

  LargeAsteroid.fullInit(
    Vector2 position,
    Vector2 velocity,
    Vector2 resolutionMultiplier,
    Vector2? size,
    double? speed,
    int? hp,
    int? attack,
  ) : super.fullInit(
          position,
          velocity,
          resolutionMultiplier,
          size: size,
          speed: speed ?? defaultSpeed,
          hp: hp,
          attack: attack,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //_velocityは単位Vectorなので、実際の速度を考慮する必要があります
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
  }

  @override
  void onCreate() {
    super.onCreate();
    debugPrint("LargeAsteroid onCreate called");
  }

  @override
  void onDestroy() {
    debugPrint("LargeAsteroid onDestroy called");
  }

  @override
  void onHit(CollisionCallbacks other) {
    debugPrint("LargeAsteroid onHit called");
  }

  @override
  List<AsteroidEnum> getSplitAsteroids() {
    return [AsteroidEnum.mediumAsteroid, AsteroidEnum.mediumAsteroid];
  }
}

class AsteroidFactory {
  AsteroidFactory._();

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
            context.hp,
            context.attack,
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
            context.hp,
            context.attack,
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
            context.hp,
            context.attack,
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
    //インスタンスを渡す前に、必要な動作を発火させる
    result.onCreate();
    return result;
  }
}

//これは新規作成時のコンテキストデータのためのシンプルなデータホルダー
class AsteroidBuildContext {
  static const double defaultSpeed = 0;
  static const int defaultHp = 1;
  static const int defaultAttack = 1;
  static final Vector2 defaultVelocity = Vector2.zero();
  static final Vector2 defaultPosition = Vector2(-1, -1);
  static final Vector2 defaultSize = Vector2.zero();
  static final AsteroidEnum defaultAsteroidType = AsteroidEnum.values[0];
  static final Vector2 defaultMultiplier = Vector2.all(1.0);

  //文字列を対応する列挙値にパースするためのもの
  static AsteroidEnum asteroidFromString(String value) {
    return AsteroidEnum.values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == value.toUpperCase(),
    );
  }

  double speed = defaultSpeed;
  Vector2 velocity = defaultVelocity;
  Vector2 position = defaultPosition;
  Vector2 size = defaultSize;
  int hp = defaultHp;
  int attack = defaultAttack;
  Vector2 multiplier = defaultMultiplier;
  AsteroidEnum asteroidType = defaultAsteroidType;

  AsteroidBuildContext();

  @override
  String toString() {
    return 'name: $asteroidType , speed: $speed , position: $position , velocity: $velocity, multiplier: $multiplier';
  }
}
