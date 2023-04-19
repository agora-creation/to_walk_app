import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/jump/game_controller.dart';
import 'package:to_walk_app/games/jump/objects/background.dart';
import 'package:to_walk_app/games/jump/objects/bottom_area.dart';
import 'package:to_walk_app/games/jump/objects/top_area.dart';
import 'package:to_walk_app/games/jump/ui/game_end.dart';
import 'package:to_walk_app/games/jump/ui/game_start.dart';
import 'package:to_walk_app/games/jump/ui/game_ui.dart';
import 'package:to_walk_app/providers/user.dart';

class JumpGameWidget extends StatelessWidget {
  final bool tutorialSkip;

  const JumpGameWidget({
    this.tutorialSkip = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    int level = userProvider.alk?.level ?? 0;

    return GameWidget(
      game: JumpGame(
        level: level,
        tutorialSkip: tutorialSkip,
      ),
      overlayBuilderMap: {
        'GameStart': (context, JumpGame game) {
          return JumpGameStart(game: game);
        },
        'GameEnd': (context, JumpGame game) {
          return JumpGameEnd(game: game);
        },
      },
    );
  }
}

class JumpGame extends Forge2DGame with TapDetector {
  final int level;
  final bool tutorialSkip;

  JumpGame({
    required this.level,
    required this.tutorialSkip,
  }) : super(zoom: 100, gravity: Vector2(0, 9.8));

  late JumpGameController controller;
  late TimerComponent timer;
  bool tutorialView = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(screenSize);
    add(BackgroundObject());
    add(TopArea());
    add(BottomArea());
    add(JumpGameUI());
    controller = JumpGameController();
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
    if (controller.currentTime > 60) {
      controller.gameFinish();
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    controller.player.jump();
  }
}
