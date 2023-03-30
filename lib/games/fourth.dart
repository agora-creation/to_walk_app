import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/time_ball.dart';
import 'package:to_walk_app/games/utils.dart';

class FourthGame extends FlameGame with HasCollisionDetection {
  static const int numSimulationObjects = 10;
  Set<String> observedCollisions = {};
  final TextPaint textConfig = TextPaint(
    style: const TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
  );
  late TimerComponent interval;
  int elapsedTicks = 0;

  @override
  Future onLoad() async {
    super.onLoad();
    interval = TimerComponent(
      period: 1,
      removeOnFinish: true,
      autoStart: true,
      onTick: () {
        Vector2 rndPosition = Utils.generateRandomPosition(
          size,
          Vector2.all(50),
        );
        Vector2 rndVelocity = Utils.generateRandomDirection();
        double rndSpeed = Utils.generateRandomSpeed(20, 100);
        TimeBall ball = TimeBall(
          rndPosition,
          rndVelocity,
          rndSpeed,
          elapsedTicks,
        );
        add(ball);
        elapsedTicks++;
        if (elapsedTicks > numSimulationObjects) {
          interval.timer.stop();
          remove(interval);
        }
      },
      repeat: true,
    );
    add(interval);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textConfig.render(
      canvas,
      'Elapsed # ticks: $elapsedTicks',
      Vector2(10, 30),
    );
    textConfig.render(
      canvas,
      'Number of objects alive: ${children.length}',
      Vector2(10, 60),
    );
  }
}
