import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/catch/objects/fall_item.dart';
import 'package:to_walk_app/games/catch/objects/ground.dart';
import 'package:to_walk_app/games/catch/objects/player.dart';
import 'package:to_walk_app/games/catch/ui/game_end.dart';
import 'package:to_walk_app/games/catch/ui/game_start.dart';
import 'package:to_walk_app/games/catch/ui/game_ui.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/resources.dart';

class CatchGameWidget extends StatelessWidget {
  const CatchGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: CatchGame(),
      overlayBuilderMap: {
        'GameStart': (context, CatchGame game) {
          return GameStart(game: game);
        },
        'GameEnd': (context, CatchGame game) {
          return GameEnd(game: game);
        },
      },
    );
  }
}

class CatchGame extends Forge2DGame with TapDetector {
  CatchGame() : super(zoom: 100, gravity: Vector2(0, 9.8));

  late final PlayerObject player;
  int score = 0;
  bool isStart = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(screenSize);

    final bg = SpriteComponent(
      sprite: Resources.bg,
      size: screenSize,
    )..positionType = PositionType.viewport;
    add(bg);

    add(GameUI());
    add(GroundObject());

    player = PlayerObject();
    await add(player);

    await add(FallItemObject(
      x: worldSize.x * Random().nextDouble(),
      y: -1,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isStart) {
      findGame()?.overlays.add('GameStart');
      findGame()?.paused = true;
      isStart = false;
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    double tapX = info.eventPosition.game.x;
    player.move(tapX);
  }
}
