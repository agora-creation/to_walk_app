import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/jumping/common.dart';
import 'package:to_walk_app/games/jumping/objects/hero.dart';
import 'package:to_walk_app/games/jumping/objects/platform.dart';

class JumpingGameWidget extends StatelessWidget {
  const JumpingGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: FlameGame());
  }
}

class JumpingGame extends Forge2DGame
    with HasKeyboardHandlerComponents, TapDetector {
  late final MyHero hero;
  int score = 0;
  int coins = 0;
  int bullets = 0;
  double generatedWorldHeight = 6.7;
  var state = GameState.running;

  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

  @override
  void onTapUp(TapUpInfo info) {
    // TODO: implement onTapUp
    super.onTapUp(info);
  }

  bool isOutOfScreen(Vector2 position) {
    return false;
  }

  void generateNextSectionOfWorld() {}

  void addBrokenPlatformPieces(Platform platform) {}

  void addCoins() {}

  void addBullets() {}
}
