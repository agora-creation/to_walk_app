import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/jump/game.dart';

final _textPaint = TextPaint(
  style: const TextStyle(
    color: Color(0xFF333333),
    fontSize: 40,
    fontWeight: FontWeight.bold,
    fontFamily: 'TsunagiGothic',
  ),
);

class JumpGameUI extends PositionComponent with HasGameRef<JumpGame> {
  final totalScore = TextComponent(textRenderer: _textPaint);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    positionType = PositionType.viewport;
    position.y = 25;
    priority = 3;

    add(totalScore);
  }

  @override
  void update(double dt) {
    super.update(dt);
    totalScore.text = 'スコア : ${game.controller.score}m';
    totalScore.position
      ..x = 20
      ..y = 10;
  }
}
