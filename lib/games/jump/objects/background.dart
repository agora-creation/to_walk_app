import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:to_walk_app/games/jump/game.dart';

class BackgroundObject extends ParallaxComponent<JumpGame> {
  BackgroundObject() : super(priority: -1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('games/jump/parallax/bg.png'),
        ParallaxImageData('games/jump/parallax/mountain-far.png'),
        ParallaxImageData('games/jump/parallax/mountains.png'),
        ParallaxImageData('games/jump/parallax/trees.png'),
        ParallaxImageData('games/jump/parallax/foreground-trees.png'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
    );
  }
}
