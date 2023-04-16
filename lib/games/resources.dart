import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Resources {
  static late final Sprite bg;
  static late final Sprite ground;

  static Future<void> load() async {
    bg = await _loadSprite('games/bg.png');
    ground = await _loadSprite('games/ground.jpg');
  }

  static Future<Sprite> _loadSprite(String fileName) async {
    return Sprite(await Flame.images.load(fileName));
  }
}
