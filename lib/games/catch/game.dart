import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/games/catch/game_controller.dart';
import 'package:to_walk_app/games/catch/objects/ground.dart';
import 'package:to_walk_app/games/catch/ui/game_end.dart';
import 'package:to_walk_app/games/catch/ui/game_start.dart';
import 'package:to_walk_app/games/catch/ui/game_ui.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/resources.dart';
import 'package:to_walk_app/providers/user.dart';

class CatchGameWidget extends StatelessWidget {
  final bool tutorialSkip;

  const CatchGameWidget({
    this.tutorialSkip = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    int level = userProvider.alk?.level ?? 0;

    return GameWidget(
      game: CatchGame(
        level: level,
        tutorialSkip: tutorialSkip,
      ),
      overlayBuilderMap: {
        'GameStart': (context, CatchGame game) {
          return CatchGameStart(game: game);
        },
        'GameEnd': (context, CatchGame game) {
          return CatchGameEnd(game: game);
        },
      },
    );
  }
}

class CatchGame extends Forge2DGame with TapDetector {
  final int level;
  final bool tutorialSkip;

  CatchGame({
    required this.level,
    required this.tutorialSkip,
  }) : super(zoom: 100, gravity: Vector2(0, 9.8));

  late CatchGameController controller;
  late TimerComponent timer;
  bool tutorialView = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(screenSize);
    final bg = SpriteComponent(
      sprite: Resources.catchBg,
      size: screenSize,
    )..positionType = PositionType.viewport;
    add(bg);
    add(SpriteComponent(
      sprite: Resources.catchCloud,
      size: Vector2(worldSize.x, 2.8),
      position: Vector2(worldSize.x / 2, 1),
      anchor: Anchor.center,
      priority: 2,
    ));
    add(GroundObject());
    add(CatchGameUI());
    controller = CatchGameController();
    add(controller);
    timer = TimerComponent(
      period: 1,
      repeat: true,
      onTick: () => controller.onTick(),
    );
    await controller.init(level: level);
    add(timer);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!tutorialSkip) {
      if (tutorialView) {
        findGame()?.overlays.add('GameStart');
        findGame()?.paused = true;
        tutorialView = false;
      }
    }
    if (controller.currentCarrots.isEmpty) {
      controller.gameFinish();
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    double tapX = info.eventPosition.game.x;
    controller.player.move(tapX);
  }
}
