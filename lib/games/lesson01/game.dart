import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_walk_app/games/lesson01/ball.dart';

class Lesson01GameScreen extends StatefulWidget {
  const Lesson01GameScreen({Key? key}) : super(key: key);

  @override
  State<Lesson01GameScreen> createState() => _Lesson01GameScreenState();
}

class _Lesson01GameScreenState extends State<Lesson01GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: Lesson01Game(context)),
    );
  }
}

final screenSize = Vector2(1280, 720);

class Lesson01Game extends Forge2DGame with KeyboardEvents {
  final BuildContext context;

  Lesson01Game(this.context) : super(zoom: 100, gravity: Vector2(0, 15));

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

    add(Ball());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    totalBodies.text = 'Bodies: ${world.bodies.length}';
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set keysPressed) {
    if (event is RawKeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.escape)) {
        Navigator.pop(context);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
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
