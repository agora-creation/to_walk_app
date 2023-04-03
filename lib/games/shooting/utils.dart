//Vectorに関するプログラム

import 'dart:math';

import 'package:flame/components.dart';

class Utils {
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

  //Componentに対してランダムな位置を生成する
  static Vector2 generateRandomPosition(Vector2 screenSize, Vector2 margins) {
    Vector2 result = Vector2.zero();
    final Random rnd = Random();
    result = Vector2(
      rnd.nextInt(screenSize.x.toInt() - 2 * margins.x.toInt()).toDouble() +
          margins.x,
      rnd.nextInt(screenSize.y.toInt() - 2 * margins.y.toInt()).toDouble() +
          margins.y,
    );
    return result;
  }

  //Componentに対してランダムな方向と速度を生成する
  //これにより、単位円上でランドマーク化された方向Vectorが作成されます
  //minとmaxはスピートの範囲
  static Vector2 generateRandomVelocity(Vector2 screenSize, int min, int max) {
    Vector2 result = Vector2.zero();
    final Random rnd = Random();
    double velocity;
    while (result == Vector2.zero()) {
      result = Vector2(
        (rnd.nextInt(3) - 1) * rnd.nextDouble(),
        (rnd.nextInt(3) - 1) * rnd.nextDouble(),
      );
    }
    result.normalize();
    velocity = (rnd.nextInt(max - min) + min).toDouble();
    return result * velocity;
  }

  //Componentに対してランダムな方向を生成する
  //これにより、単位円上でランドマーク化された方向Vectorが作成されます
  static Vector2 generateRandomDirection() {
    Vector2 result = Vector2.zero();
    final Random rnd = Random();
    while (result == Vector2.zero()) {
      result = Vector2(
        (rnd.nextInt(3) - 1) * rnd.nextDouble(),
        (rnd.nextInt(3) - 1) * rnd.nextDouble(),
      );
    }
    return result;
  }
}
