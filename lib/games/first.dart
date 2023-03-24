import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class FirstGame extends FlameGame with TapDetector {
  @override
  bool debugMode = false;

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
        ..color = (BasicPalette.red.paint()
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
  var color = BasicPalette.white.paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  @override
  Future onLoad() async {
    super.onLoad();
    size.setValues(squareSize, squareSize);
    anchor = Anchor.bottomCenter;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
    var angleDelta = dt * rotationSpeed;
    angle = (angle - angleDelta) % (2 * pi);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), color);
  }
}
