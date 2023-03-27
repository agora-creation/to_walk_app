import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/lifebar.dart';

class FirstGame extends FlameGame with TapDetector {
  final TextPaint textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 14,
      fontFamily: 'TsunagiGothic',
    ),
  );

  @override
  void onTapUp(TapUpInfo info) {
    final touchPoint = info.eventPosition.game;

    final handled = children.any((component) {
      if (component is Square && component.containsPoint(touchPoint)) {
        component.processHit();
        component.velocity.negate();
        return true;
      }
      return false;
    });

    if (!handled) {
      add(Square()
        ..position = touchPoint
        ..squareSize = 45.0
        ..velocity = Vector2(0, 1).normalized() * 25
        ..color = (Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2));
    }
  }

  @override
  void render(Canvas canvas) {
    textPaint.render(
      canvas,
      "四角はいま${children.length}",
      Vector2(10, 20),
    );
    super.render(canvas);
  }
}

class Square extends PositionComponent {
  var velocity = Vector2(0, 25);
  var rotationSpeed = 0.3;
  var squareSize = 128.0;
  var color = Paint()
    ..color = Colors.orange
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  late LifeBar lifeBar;

  @override
  Future onLoad() async {
    super.onLoad();
    size.setValues(squareSize, squareSize);
    anchor = Anchor.center;

    createLifeBar();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), color);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    var angleDelta = dt * rotationSpeed;
    angle = (angle - angleDelta) % (2 * pi);
  }

  createLifeBar() {
    lifeBar = LifeBar.initData(
      size,
      size: Vector2(size.x - 10, 5),
      placement: LifeBarPlacement.center,
    );
    add(lifeBar);
  }

  processHit() {
    lifeBar.decrementCurrentLifeBy(10);
  }
}
