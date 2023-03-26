import 'dart:math';

import 'package:flame/components.dart';

class Utils {
  static Vector2 generateRandomPosition(Vector2 screenSize, Vector2 margins) {
    var result = Vector2.zero();
    var randomGenerator = Random();
    var x = randomGenerator
        .nextInt(screenSize.x.toInt() - 2 * margins.x.toInt())
        .toDouble();
    var y = randomGenerator
        .nextInt(screenSize.y.toInt() - 2 * margins.y.toInt())
        .toDouble();
    result = Vector2(x, y);
    return result;
  }

  static Vector2 generateRandomVelocity(Vector2 screenSize, int min, int max) {
    var result = Vector2.zero();
    var randomGenerator = Random();
    double velocity;
    while (result == Vector2.zero()) {
      var x = (randomGenerator.nextInt(3) - 1) * randomGenerator.nextDouble();
      var y = (randomGenerator.nextInt(3) - 1) * randomGenerator.nextDouble();
      result = Vector2(x, y);
    }
    result.normalize();
    velocity = (randomGenerator.nextInt(max - min) + min).toDouble();
    return result * velocity;
  }
}
