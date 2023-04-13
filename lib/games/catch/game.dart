import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/catch/objects/ground.dart';
import 'package:to_walk_app/games/catch/objects/player.dart';
import 'package:to_walk_app/helpers/common.dart';

class CatchGameWidget extends StatelessWidget {
  const CatchGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: CatchGame());
  }
}

class CatchGame extends Forge2DGame with TapDetector {
  CatchGame() : super(zoom: 100, gravity: Vector2(0, 9.8));

  late final PlayerObject player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(screenSize);

    //背景

    await add(GroundObject());

    player = PlayerObject();
    await add(player);
  }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    double tapX = info.eventPosition.game.x;
    if ((worldSize.x / 2) > tapX) {
      player.moveLeft();
    } else if ((worldSize.x / 2) < tapX) {
      player.moveRight();
    } else {
      player.moveStop();
    }
  }
}
