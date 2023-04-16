import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/common.dart';
import 'package:to_walk_app/games/jumping/assets.dart';
import 'package:to_walk_app/games/jumping/objects/bullet.dart';
import 'package:to_walk_app/games/jumping/objects/cloud_enemy.dart';
import 'package:to_walk_app/games/jumping/objects/coin.dart';
import 'package:to_walk_app/games/jumping/objects/floor.dart';
import 'package:to_walk_app/games/jumping/objects/hearth_enemy.dart';
import 'package:to_walk_app/games/jumping/objects/hero.dart';
import 'package:to_walk_app/games/jumping/objects/platform.dart';
import 'package:to_walk_app/games/jumping/objects/platform_pieces.dart';
import 'package:to_walk_app/games/jumping/objects/power_up.dart';
import 'package:to_walk_app/games/jumping/ui/game_over_menu.dart';
import 'package:to_walk_app/games/jumping/ui/game_ui.dart';
import 'package:to_walk_app/games/jumping/ui/pause_menu.dart';

class JumpingGameWidget extends StatelessWidget {
  const JumpingGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: JumpingGame(),
      overlayBuilderMap: {
        'GameOverMenu': (context, JumpingGame game) {
          return GameOverMenu(game: game);
        },
        'PauseMenu': (context, JumpingGame game) {
          return PauseMenu(game: game);
        },
      },
    );
  }
}

class JumpingGame extends Forge2DGame
    with HasKeyboardHandlerComponents, TapDetector {
  late final MyHero hero;
  int score = 0;
  int coins = 0;
  int bullets = 0;
  double generatedWorldHeight = 6.7;
  // var state = GameState.running;

  //screenSizeを100倍に拡大し、重力を9.8とする
  JumpingGame() : super(zoom: 100, gravity: Vector2(0, 9.8));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(screenSize);

    final background = SpriteComponent(
      sprite: Assets.background,
      size: screenSize,
    )..positionType = PositionType.viewport;
    add(background);

    add(GameUI());
    add(Floor());
    hero = MyHero();
    await add(hero);

    //カメラの移動できる距離を設定
    final worldBounds = Rect.fromLTRB(
      0,
      -double.infinity,
      worldSize.x,
      worldSize.y,
    );
    camera.followBodyComponent(hero, worldBounds: worldBounds);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // if (state == GameState.running) {
    //   if (generatedWorldHeight > hero.body.position.y - worldSize.y / 2) {
    //     //World生成
    //     generateNextSectionOfWorld();
    //   }
    //
    //   final heroY = (hero.body.position.y - worldSize.y) * -1;
    //   if (score < heroY) {
    //     score = heroY.toInt();
    //   }
    //   if (score - 7 > heroY) {
    //     hero.hit();
    //   }
    //   if (hero.state == HeroState.dead && (score - worldSize.y) > heroY) {
    //     state = GameState.gameOver;
    //     HighScores.save(score);
    //     overlays.add('GameOverMenu');
    //   }
    // }
  }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    //hero.fireBullet();
    findGame()?.overlays.add('PauseMenu');
    findGame()?.paused = true;
  }

  bool isOutOfScreen(Vector2 position) {
    final heroY = (hero.body.position.y - worldSize.y) * -1;
    final otherY = (position.y - worldSize.y) * -1;
    return otherY < heroY - worldSize.y / 2;
  }

  void generateNextSectionOfWorld() {
    for (int i = 0; i < 10; i++) {
      add(Platform(
        x: worldSize.x * Random().nextDouble(),
        y: generatedWorldHeight,
      ));
      add(Platform(
        x: worldSize.x * Random().nextDouble(),
        y: generatedWorldHeight,
      ));

      if (Random().nextBool()) {
        add(HearthEnemy(
          x: worldSize.x * Random().nextDouble(),
          y: generatedWorldHeight - 1.5,
        ));
      } else if (Random().nextDouble() < .2) {
        add(CloudEnemy(
          x: worldSize.x * Random().nextDouble(),
          y: generatedWorldHeight - 1.5,
        ));
      }

      if (Random().nextDouble() < .3) {
        add(PowerUp(
          x: worldSize.x * Random().nextDouble(),
          y: generatedWorldHeight - 1.5,
        ));
        if (Random().nextDouble() < .2) {
          addCoins();
        }
      }

      generatedWorldHeight -= 2.7;
    }
  }

  void addBrokenPlatformPieces(Platform platform) {
    final x = platform.body.position.x;
    final y = platform.body.position.y;
    final leftSide = PlatformPieces(
      x: x - (PlatformPieces.size.x / 2),
      y: y,
      isLeftSide: true,
      type: platform.type,
    );
    final rightSide = PlatformPieces(
      x: x - (PlatformPieces.size.x / 2),
      y: y,
      isLeftSide: false,
      type: platform.type,
    );
    add(leftSide);
    add(rightSide);
  }

  void addCoins() {
    final rows = Random().nextInt(15) + 1;
    final cols = Random().nextInt(5) + 1;
    final x = (worldSize.x - (Coin.size.x * cols)) * Random().nextDouble() +
        Coin.size.x / 2;
    for (int col = 0; col < cols; col++) {
      for (int row = 0; row <= rows; row++) {
        add(Coin(
          x: x + (col * Coin.size.x),
          y: generatedWorldHeight + (row * Coin.size.y) - 2,
        ));
      }
    }
  }

  void addBullets() {
    bullets -= 3;
    if (bullets < 0) bullets = 0;
    if (bullets == 0) return;
    final x = hero.body.position.x;
    final y = hero.body.position.y;

    add(Bullet(x: x, y: y, accelX: -1.5));
    add(Bullet(x: x, y: y, accelX: 0));
    add(Bullet(x: x, y: y, accelX: 1.5));
  }
}
