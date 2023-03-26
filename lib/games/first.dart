import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class FirstGame extends FlameGame with TapDetector {
  static const description = '''
    これが説明です。
    これが説明です。これが説明です。
  ''';

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
        //remove(component);
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
  var color = Paint()
    ..color = Colors.orange
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  List<RectangleComponent> lifeBarElements = List<RectangleComponent>.filled(
    3,
    RectangleComponent(size: Vector2(1, 1)),
    growable: false,
  );

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

  void createLifeBar() {
    var lifeBarSize = Vector2(40, 10);
    var backgroundFillColor = Paint()
      ..color = Colors.grey.withOpacity(0.35)
      ..style = PaintingStyle.fill;
    var outlineColor = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    var lifeDangerColor = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    lifeBarElements = [
      RectangleComponent(
        position: Vector2(size.x - lifeBarSize.x, -lifeBarSize.y - 2),
        size: lifeBarSize,
        angle: 0,
        paint: outlineColor,
      ),
      RectangleComponent(
        position: Vector2(size.x - lifeBarSize.x, -lifeBarSize.y - 2),
        size: lifeBarSize,
        angle: 0,
        paint: backgroundFillColor,
      ),
      RectangleComponent(
        position: Vector2(size.x - lifeBarSize.x, -lifeBarSize.y - 2),
        size: Vector2(10, 10),
        angle: 0,
        paint: lifeDangerColor,
      ),
    ];
    addAll(lifeBarElements);
  }
}
