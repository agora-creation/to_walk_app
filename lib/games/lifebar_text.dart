import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LifeBarText extends TextComponent {
  final TextPaint textBallStats = TextPaint(
    style: const TextStyle(
      color: Colors.red,
      fontSize: 10,
    ),
  );
  var ordinalformatter = NumberFormat('000', 'ja');
  var healthDataformatter = NumberFormat('000', 'ja');

  int _ordinalNumber = 0;
  int healthData = 0;

  LifeBarText(int ordinalNumber) {
    _ordinalNumber = ordinalNumber;
  }

  @override
  Future onLoad() async {
    textRenderer = textBallStats;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    text = '#${ordinalformatter.format(_ordinalNumber)}'
        ' - ${healthDataformatter.format(healthData)}%';
    super.update(dt);
  }
}
