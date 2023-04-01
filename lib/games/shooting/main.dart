import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/bullet.dart';
import 'package:to_walk_app/games/shooting/joystick_player.dart';

class ShootingMainGame extends StatefulWidget {
  const ShootingMainGame({Key? key}) : super(key: key);

  @override
  State<ShootingMainGame> createState() => _ShootingMainGameState();
}

class _ShootingMainGameState extends State<ShootingMainGame> {
  final game = ShootingGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}

class ShootingGame extends FlameGame with HasDraggables, HasTappables {
  late final JoystickPlayer player;

  late final JoystickComponent joystick;

  final TextPaint shipAngleTextPaint = TextPaint();

  @override
  Future onLoad() async {
    await super.onLoad();
    final knobPaint = BasicPalette.green.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.green.withAlpha(100).paint();

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 15, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );

    player = JoystickPlayer(joystick);

    add(player);
    add(joystick);
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    var velocity = Vector2(0, -1);
    velocity.rotate(player.angle);
    BulletBuildContext context = BulletBuildContext()
      ..speed = 50
      ..position = player.muzzleComponent.absolutePosition
      ..velocity = velocity
      ..size = Vector2(4, 4);
    Bullet myBullet = BulletFactory.create(BulletEnum.slowBullet, context);
    add(myBullet);
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
