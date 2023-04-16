import 'package:flame/components.dart';

final screenSize = Vector2(750, 1334);
final worldSize = Vector2(7.54, 13.34);

bool isOutOfScreen(Vector2 position) {
  bool result = false;
  if (position.x > worldSize.x ||
      position.x < 0 ||
      position.y < 0 ||
      position.y > worldSize.y) {
    result = true;
  }
  return result;
}

Vector2 wrapPosition(Vector2 position) {
  Vector2 result = position;
  if (position.x >= worldSize.x) {
    result.x = 0;
  } else if (position.x <= 0) {
    result.x = worldSize.x;
  }
  if (position.y >= worldSize.y) {
    result.y = 0;
  } else if (position.y <= 0) {
    result.y = worldSize.y;
  }
  return result;
}
