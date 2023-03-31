import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class SixthGame extends FlameGame with TapDetector {
  @override
  Future onLoad() async {
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpInfo info) {
    add(ParticleGenerator.createParticleEngine(
      position: info.eventPosition.game,
    ));
  }
}

class ParticleGenerator {
  static ParticleSystemComponent createParticleEngine({
    required Vector2 position,
  }) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 30,
        lifespan: 3,
        generator: (i) => AcceleratedParticle(
          acceleration: randomVector()..scale(200),
          position: position,
          child: CircleParticle(
            paint: Paint()..color = Colors.red,
            radius: 2,
          ),
        ),
      ),
    );
  }

  static Vector2 randomVector() {
    Vector2 result;
    final Random rnd = Random();
    const int min = -1;
    const int max = 1;
    double numX = min + ((max - min) * rnd.nextDouble());
    double numY = min + ((max - min) * rnd.nextDouble());
    result = Vector2(numX, numY);
    return result;
  }
}
