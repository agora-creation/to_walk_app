import 'package:flame/components.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/games/catch/objects/carrot.dart';
import 'package:to_walk_app/games/catch/objects/player.dart';
import 'package:to_walk_app/games/catch/objects/thunder.dart';
import 'package:to_walk_app/games/json_utils.dart';
import 'package:to_walk_app/games/scores.dart';

class CatchGameController extends Component with HasGameRef<CatchGame> {
  int score = 0;
  int currentTime = 0;
  late dynamic jsonData;
  late List<ThunderObject> bombs;
  late List<CarrotObject> carrots;
  List<CarrotObject> currentCarrots = [];
  late PlayerObject player;
  int alkLevel = 0;

  PlayerObject getPlayer() => player;

  Future<void> init({required int level}) async {
    alkLevel = level;
    jsonData = await JsonUtils.readCatch();
    bombs = JsonUtils.extractBomb(jsonData);
    carrots = JsonUtils.extractCarrot(jsonData);
    currentCarrots = carrots;
    if (gameRef.tutorialSkip) {
      await setPlayer();
    }
  }

  Future<void> setPlayer() async {
    player = PlayerObject(level: alkLevel);
    await add(player);
  }

  void onTick() {
    currentTime++;
    for (final bomb in bombs) {
      if (bomb.time == currentTime) {
        gameRef.add(bomb);
      }
    }
    for (final carrot in carrots) {
      if (carrot.time == currentTime) {
        gameRef.add(carrot);
      }
    }
  }

  void addScore(int value) {
    score += value;
  }

  void gameFinish() async {
    await Future.delayed(const Duration(seconds: 1));
    findGame()?.overlays.add('GameEnd');
    findGame()?.paused = true;
    Scores.catchSave(score);
  }
}
