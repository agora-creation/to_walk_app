import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

class FifthGame extends FlameGame {
  final _layersMeta = {
    'bg.png': 1.0,
    'mountain-far.png': 1.5,
    'mountains.png': 2.3,
    'trees.png': 5.0,
    'foreground-trees.png': 24.0,
  };

  @override
  Future onLoad() async {
    final layers = _layersMeta.entries.map((e) {
      return loadParallaxLayer(
        ParallaxImageData(e.key),
        velocityMultiplier: Vector2(e.value, 1),
      );
    });
    final parallax = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(20, 0),
      ),
    );
    add(parallax);
  }
}
