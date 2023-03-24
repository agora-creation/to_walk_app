import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class FirstGame extends FlameGame with TapDetector {
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
        ..velocity = Vector2(0, 1).normalized() * 50
        ..color = (BasicPalette.red.paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2));
    }
  }
}

class Square extends PositionComponent {
  var velocity = Vector2(0, 0).normalized() * 25;
  var squareSize = 128.0;
  var color = BasicPalette.white.paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  @override
  Future onLoad() async {
    super.onLoad();
    size.setValues(squareSize, squareSize);
    anchor = Anchor.topRight;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), color);
  }
}
