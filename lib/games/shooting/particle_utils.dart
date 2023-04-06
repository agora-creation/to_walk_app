import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/utils.dart';

enum ExplosionEnum {
  largeParticleExplosion,
  mediumParticleExplosion,
  fieryExplosion,
  bonusExplosion,
}

abstract class Explosion {
  static const double defaultLifeSpan = 1;
  static const int defaultParticleCount = 1;
  static final Vector2 defaultPosition = Vector2(-1, -1);
  static final Vector2 defaultSize = Vector2.zero();
  static final ExplosionEnum defaultExplosionType = ExplosionEnum.values[0];
  static final Vector2 defaultMultiplier = Vector2.all(1);

  double _lifespan = defaultLifeSpan;
  late Vector2 _position = defaultPosition;
  Vector2 _size = defaultSize;
  int _particleCount = defaultParticleCount;
  late Vector2 _resolutionMultiplier = defaultMultiplier;
  Images? _images;

  Explosion(
    Vector2 resolutionMultiplier,
    Vector2 position,
  )   : _resolutionMultiplier = resolutionMultiplier,
        _position = position;

  Explosion.fullInit(
    Vector2 resolutionMultiplier,
    Vector2 position, {
    double? lifeSpan,
    int? particleCount,
    Vector2? size,
    Images? images,
  })  : _resolutionMultiplier = resolutionMultiplier,
        _position = position,
        _lifespan = lifeSpan ?? defaultLifeSpan,
        _particleCount = particleCount ?? defaultParticleCount,
        _size = size ?? defaultSize,
        _images = images;

  Future onCreate();

  void onHit(CollisionCallback other);

  //呼び出し元に対して、実際のパーティクルシュミレーションを作成
  ParticleSystemComponent getParticleSimulation(Vector2 position);
}

class ParticleExplosion360 extends Explosion {
  static const double defaultLifeSpan = 3;
  static final Vector2 defaultSize = Vector2.all(2);
  static const int defaultParticleCount = 45;
  static final _paint = Paint()..color = Colors.red;

  ParticleExplosion360(
    Vector2 resolutionMultiplier,
    Vector2 position,
  ) : super.fullInit(
          resolutionMultiplier,
          position,
          size: defaultSize,
          lifeSpan: defaultLifeSpan,
          particleCount: defaultParticleCount,
        );

  ParticleExplosion360.fullInit(
    Vector2 resolutionMultiplier,
    Vector2 position,
    Vector2? size,
    double? lifeSpan,
    int? particleCount,
  ) : super.fullInit(
          resolutionMultiplier,
          position,
          size: size,
          lifeSpan: lifeSpan,
          particleCount: particleCount,
        );

  @override
  void onHit(CollisionCallback other) {
    // TODO: implement onHit
  }

  @override
  Future onCreate() {
    // TODO: implement onCreate
    throw UnimplementedError();
  }

  @override
  ParticleSystemComponent getParticleSimulation(Vector2 position) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: _particleCount,
        lifespan: _lifespan,
        generator: (i) => AcceleratedParticle(
          acceleration: Utils.randomVector()..scale(100),
          position: _position,
          child: CircleParticle(
            paint: Paint()..color = _paint.color,
            radius: _size.x / 2,
          ),
        ),
      ),
    );
  }
}

class ParticleBonusExplosion extends Explosion {
  static const double defaultLifeSpan = 3;
  static final Vector2 defaultSize = Vector2.all(2);
  static const int defaultParticleCount = 45;
  static final _paint = Paint()..color = Colors.white;

  ParticleBonusExplosion(
    Vector2 resolutionMultiplier,
    Vector2 position,
  ) : super.fullInit(
          resolutionMultiplier,
          position,
          size: defaultSize,
          lifeSpan: defaultLifeSpan,
          particleCount: defaultParticleCount,
        );

  ParticleBonusExplosion.fullInit(
    Vector2 resolutionMultiplier,
    Vector2 position,
    Vector2? size,
    double? lifeSpan,
    int? particleCount,
  ) : super.fullInit(
          resolutionMultiplier,
          position,
          size: size,
          lifeSpan: lifeSpan,
          particleCount: particleCount,
        );

  @override
  void onHit(CollisionCallback other) {
    // TODO: implement onHit
  }

  @override
  Future onCreate() {
    // TODO: implement onCreate
    throw UnimplementedError();
  }

  @override
  ParticleSystemComponent getParticleSimulation(Vector2 position) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: _particleCount,
        lifespan: _lifespan,
        generator: (i) => AcceleratedParticle(
          acceleration: Utils.randomVector()..scale(100),
          position: _position,
          child: CircleParticle(
            paint: Paint()..color = _paint.color,
            radius: _size.x / 2,
          ),
        ),
      ),
    );
  }
}

class FieryExplosion extends Explosion {
  static const double defaultLifeSpan = 3;
  static final Vector2 defaultSize = Vector2.all(1.5);
  static final _paint = Paint()..color = Colors.red;

  FieryExplosion(
    Vector2 resolutionMultiplier,
    Vector2 position,
  ) : super.fullInit(
          resolutionMultiplier,
          position,
          size: defaultSize,
          lifeSpan: defaultLifeSpan,
          particleCount: Explosion.defaultParticleCount,
        );

  FieryExplosion.fullInit(
    Vector2 resolutionMultiplier,
    Vector2 position,
    Vector2? size,
    double? lifeSpan,
    int? particleCount,
    Images? images,
  ) : super.fullInit(
          resolutionMultiplier,
          position,
          size: size,
          lifeSpan: lifeSpan,
          particleCount: particleCount,
          images: images,
        );

  @override
  void onHit(CollisionCallback other) {
    // TODO: implement onHit
  }

  @override
  Future onCreate() {
    // TODO: implement onCreate
    throw UnimplementedError();
  }

  @override
  ParticleSystemComponent getParticleSimulation(Vector2 position) {
    position.sub(Vector2(200, 200));
    return ParticleSystemComponent(
      particle: AcceleratedParticle(
        lifespan: 2,
        position: position,
        child: SpriteAnimationParticle(
          animation: _getBoomAnimation(),
          size: Vector2(200, 200),
        ),
      ),
    );
  }

  SpriteAnimation _getBoomAnimation() {
    const columns = 8;
    const rows = 8;
    const frames = columns * rows;
    final spriteImage = _images!.fromCache('boom.png');
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: spriteImage,
      columns: columns,
      rows: rows,
    );
    final sprites = List<Sprite>.generate(frames, spriteSheet.getSpriteById);
    return SpriteAnimation.spriteList(sprites, stepTime: 0.1);
  }
}

class ExplosionFactory {
  ExplosionFactory._();

  static ParticleSystemComponent create(ExplosionBuildContext context) {
    Explosion preResult;
    ParticleSystemComponent result;
    switch (context.explosionType) {
      case ExplosionEnum.largeParticleExplosion:
        preResult = ParticleExplosion360(
          context.multiplier,
          context.position,
        );
        break;
      case ExplosionEnum.mediumParticleExplosion:
        preResult = ParticleExplosion360(
          context.multiplier,
          context.position,
        )
          .._particleCount = 20
          .._lifespan = 1.5;
        break;
      case ExplosionEnum.bonusExplosion:
        preResult = ParticleBonusExplosion(
          context.multiplier,
          context.position,
        )
          .._particleCount = 60
          .._lifespan = 2;
        break;
      case ExplosionEnum.fieryExplosion:
        preResult = FieryExplosion(
          context.multiplier,
          context.position,
        ).._images = context.images;
        break;
    }
    preResult.onCreate();
    result = preResult.getParticleSimulation(context.position);
    return result;
  }
}

class ExplosionBuildContext {
  static const double defaultLifeSpan = 1;
  static const int defaultParticleCount = 1;
  static final Vector2 defaultPosition = Vector2(-1, -1);
  static final Vector2 defaultSize = Vector2.zero();
  static final ExplosionEnum defaultExplosionType = ExplosionEnum.values[0];
  static final Vector2 defaultMultiplier = Vector2.all(1);

  static ExplosionEnum explosionFromString(String value) {
    return ExplosionEnum.values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == value.toUpperCase(),
    );
  }

  double lifeSpan = defaultLifeSpan;
  Vector2 position = defaultPosition;
  Vector2 size = defaultSize;
  int particleCount = defaultParticleCount;
  Vector2 multiplier = defaultMultiplier;
  ExplosionEnum explosionType = defaultExplosionType;
  Images? images;

  ExplosionBuildContext();
}
