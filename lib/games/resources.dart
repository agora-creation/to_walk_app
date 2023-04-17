import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Resources {
  static late final Sprite bg;
  static late final Sprite ground;
  static late final Sprite player;
  static late final Sprite bomb;
  static late final Sprite carrot;

  static Future<void> load() async {
    bg = await _loadSprite('games/bg.png');
    ground = await _loadSprite('games/ground.jpg');
    player = await _loadSprite('games/player.png');
    bomb = await _loadSprite('games/bomb.png');
    carrot = await _loadSprite('games/carrot.png');
  }

  static Future<Sprite> _loadSprite(String fileName) async {
    return Sprite(await Flame.images.load(fileName));
  }
}
