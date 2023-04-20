import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Resources {
  static late final Sprite catchBg;
  static late final Sprite catchCloud;
  static late final Sprite catchGround;
  static late final Sprite catchPlayerIdle;
  static late final SpriteAnimation catchPlayerWalk;
  static late final Sprite catchPlayerDead;
  static late final Sprite catchThunder;
  static late final Sprite catchCarrot;

  static late final Sprite jumpCloud;
  static late final Sprite jumpPlayerDown;
  static late final SpriteAnimation jumpPlayerUp;
  static late final Sprite jumpPlayerDead;

  static Future<void> load() async {
    catchBg = await _loadSprite('games/catch/bg.png');
    catchCloud = await _loadSprite('games/catch/cloud.png');
    catchGround = await _loadSprite('games/catch/ground.png');
    catchPlayerIdle = await _loadSprite('games/catch/player_idle.png');
    final playerWalk1 = await _loadSprite('games/catch/player_walk1.png');
    final playerWalk2 = await _loadSprite('games/catch/player_walk2.png');
    catchPlayerWalk = SpriteAnimation.spriteList(
      [playerWalk1, playerWalk2],
      stepTime: 0.1,
      loop: true,
    );
    catchPlayerDead = await _loadSprite('games/catch/player_dead.png');
    catchThunder = await _loadSprite('games/catch/thunder.png');
    catchCarrot = await _loadSprite('games/catch/carrot.png');

    jumpCloud = await _loadSprite('games/jump/cloud.png');
    jumpPlayerDown = await _loadSprite('games/jump/player_down.png');
    final playerUp1 = await _loadSprite('games/jump/player_up1.png');
    final playerUp2 = await _loadSprite('games/jump/player_up2.png');
    jumpPlayerUp = SpriteAnimation.spriteList(
      [playerUp1, playerUp2],
      stepTime: 0.1,
      loop: true,
    );
    jumpPlayerDead = await _loadSprite('games/jump/player_dead.png');
  }

  static Future<Sprite> _loadSprite(String fileName) async {
    return Sprite(await Flame.images.load(fileName));
  }
}
