import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_walk_app/games/lesson01/objects/coin.dart';
import 'package:to_walk_app/games/lesson01/objects/floor.dart';
import 'package:to_walk_app/games/lesson01/objects/platform.dart';
import 'package:to_walk_app/games/lesson01/objects/robot.dart';

final screenSize = Vector2(1280, 720);
final worldSize = Vector2(12.8, 7.2);

class Lesson01GameScreen extends StatefulWidget {
  const Lesson01GameScreen({Key? key}) : super(key: key);

  @override
  State<Lesson01GameScreen> createState() => _Lesson01GameScreenState();
}

class _Lesson01GameScreenState extends State<Lesson01GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: Lesson01Game()),
    );
  }
}

class Lesson01Game extends Forge2DGame with KeyboardEvents {
  Lesson01Game() : super(zoom: 100, gravity: Vector2(0, 15));

  final totalBodies = TextComponent(
    position: Vector2(5, 690),
  )..positionType = PositionType.viewport;
  final fps = FpsTextComponent(
    position: Vector2(5, 665),
  );

  final robot = Robot();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(screenSize);
    add(_Background(size: screenSize)..positionType = PositionType.viewport);
    add(fps);
    add(totalBodies);

    final coin1 = await loadSprite('coin/coin1.png');
    final coin2 = await loadSprite('coin/coin2.png');
    final coin3 = await loadSprite('coin/coin3.png');
    final coin4 = await loadSprite('coin/coin4.png');
    final coin5 = await loadSprite('coin/coin5.png');
    final coin6 = await loadSprite('coin/coin6.png');
    final coin7 = await loadSprite('coin/coin7.png');
    final coin8 = await loadSprite('coin/coin8.png');
    final coin9 = await loadSprite('coin/coin9.png');
    List<Sprite> coinList = [
      coin1,
      coin2,
      coin3,
      coin4,
      coin5,
      coin6,
      coin7,
      coin8,
      coin9,
    ];
    coin = SpriteAnimation.spriteList(
      coinList,
      stepTime: 0.15,
      loop: true,
    );
    await loadSprite('platform.png');
    add(Floor());

    final rnd = Random();
    const previousX = 0;
    for (int i = 0; i < 100; i++) {
      var x = (rnd.nextDouble() * (worldSize.x - 6)) + 3;
      double y = 4 - (i * 3);
      add(Platform(x: x, y: y));
      add(Coin(x: x, y: y - 1));
    }

    await add(robot);
    camera.followBodyComponent(robot);
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set keysPressed) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyW) {
        robot.jump();
      }
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      robot.walkRight();
    } else if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      robot.walkLeft();
    } else if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      robot.duck();
    } else {
      robot.idle();
    }
    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);
    totalBodies.text = 'Bodies: ${world.bodies.length}';
  }

  @override
  Color backgroundColor() {
    return Colors.red;
  }
}

class _Background extends PositionComponent {
  _Background({super.size});

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      BasicPalette.black.paint(),
    );
  }
}
