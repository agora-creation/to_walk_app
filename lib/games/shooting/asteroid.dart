import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/bullet.dart';
import 'package:to_walk_app/games/shooting/game.dart';
import 'package:to_walk_app/games/shooting/spaceship.dart';
import 'package:to_walk_app/games/shooting/utils.dart';

enum AsteroidEnum { largeAsteroid, mediumAsteroid, smallAsteroid }

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

  //デバッグ値
  @override
  String toString() {
    return '';
  }
}

//小さい小惑星
//シンプルな緑の円
//速度は150、ダメージは1、体力は1
class SmallAsteroid extends Asteroid {
  static const double defaultSpeed = 150;
  static final Vector2 defaultSize = Vector2.all(16);
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
          health: Asteroid.defaultHealth,
          damage: Asteroid.defaultDamage,
          size: defaultSize,
        );
}
