import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/lesson01/game.dart';
import 'package:to_walk_app/games/lesson02/box_kinematic.dart';
import 'package:to_walk_app/games/lesson02/floor_static.dart';

class Lesson02GameScreen extends StatefulWidget {
  const Lesson02GameScreen({Key? key}) : super(key: key);

  @override
  State<Lesson02GameScreen> createState() => _Lesson02GameScreenState();
}

class _Lesson02GameScreenState extends State<Lesson02GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: Lesson02Game(context)),
    );
  }
}

class Lesson02Game extends Forge2DGame {
  final BuildContext context;

  Lesson02Game(this.context) : super(zoom: 100, gravity: Vector2(0, 15));

  final totalBodies = TextComponent(
    position: Vector2(5, 690),
  )..positionType = PositionType.viewport;
  final fps = FpsTextComponent(position: Vector2(5, 665));

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(screenSize);
    add(_Background(size: screenSize)..positionType = PositionType.viewport);
    add(fps);
    add(totalBodies);

    add(FloorStatic());
    add(BoxKinematic());
    return super.onLoad();
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
