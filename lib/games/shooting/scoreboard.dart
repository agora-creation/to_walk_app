import 'package:flame/components.dart';
import 'package:to_walk_app/games/shooting/game.dart';

class ScoreBoard extends PositionComponent with HasGameRef<ShootingGame> {
  int _highScore = 0;
  int _numOfShotsFired = 0;
}
