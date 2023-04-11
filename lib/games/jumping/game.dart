import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';

class JumpingGameWidget extends StatelessWidget {
  const JumpingGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: FlameGame());
  }
}

class JumpingGame extends Forge2DGame
    with HasKeyboardHandlerComponents, TapDetector {
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
}
