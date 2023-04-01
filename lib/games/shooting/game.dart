import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/command.dart';
import 'package:to_walk_app/games/shooting/controller.dart';
import 'package:to_walk_app/games/shooting/spaceship.dart';

class ShootingGameScreen extends StatefulWidget {
  const ShootingGameScreen({Key? key}) : super(key: key);

  @override
  State<ShootingGameScreen> createState() => _ShootingGameScreenState();
}

class _ShootingGameScreenState extends State<ShootingGameScreen> {
  final game = ShootingGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}

class ShootingGame extends FlameGame with HasDraggables, HasTappables {
  late final Controller controller;

  late final Spaceship player;

  late final JoystickComponent joystick;

  final TextPaint shipAngleTextPaint = TextPaint();

  @override
  Future onLoad() async {
    await super.onLoad();
    controller = Controller();
    add(controller);

    final knobPaint = BasicPalette.green.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.green.withAlpha(100).paint();

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 15, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );

    player = Spaceship(joystick);

    add(player);
    add(joystick);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    UserTapUpCommand(player).addToController(controller);
    super.onTapUp(pointerId, info);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    shipAngleTextPaint.render(
      canvas,
      '${player.angle.toStringAsFixed(5)} radius',
      Vector2(20, size.y - 24),
    );
  }
}
