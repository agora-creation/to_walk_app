import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Resources {
  static late final Sprite catchBg;
  static late final Sprite catchCloud;
  static late final Sprite catchGround;
  static late final Sprite catchPlayer;
  static late final Sprite catchThunder;
  static late final Sprite catchCarrot;

  static Future<void> load() async {
    catchBg = await _loadSprite('games/catch/bg.png');
    catchCloud = await _loadSprite('games/catch/cloud.png');
    catchGround = await _loadSprite('games/catch/ground.jpg');
    catchPlayer = await _loadSprite('games/catch/player.png');
    catchThunder = await _loadSprite('games/catch/bomb.png');
    catchCarrot = await _loadSprite('games/catch/carrot.png');
  }

  static Future<Sprite> _loadSprite(String fileName) async {
    return Sprite(await Flame.images.load(fileName));
  }
}
