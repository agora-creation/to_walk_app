import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/jump/game_controller.dart';
import 'package:to_walk_app/games/jump/objects/background.dart';
import 'package:to_walk_app/games/jump/objects/floor.dart';
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
    double jump = userProvider.alk?.jump ?? 0.0;

    return GameWidget(
      game: JumpGame(
        jump: jump,
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
  final double jump;
  final bool tutorialSkip;

  JumpGame({
    required this.jump,
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
    add(Floor());
    add(JumpGameUI());
    controller = JumpGameController();
    add(controller);
    timer = TimerComponent(
      period: 1,
      repeat: true,
      onTick: () => controller.onTick(),
    );
    await controller.init();
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
  }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    controller.player.jump();
  }
}
