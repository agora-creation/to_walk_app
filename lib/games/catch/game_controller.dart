import 'package:flame/components.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/games/catch/json_utils.dart';
import 'package:to_walk_app/games/catch/objects/bomb.dart';
import 'package:to_walk_app/games/catch/objects/carrot.dart';
import 'package:to_walk_app/games/catch/objects/player.dart';
import 'package:to_walk_app/games/scores.dart';

class GameController extends Component with HasGameRef<CatchGame> {
  int score = 0;
  int currentTime = 0;
  late dynamic jsonData;
  late List<BombObject> bombs;
  late List<CarrotObject> carrots;
  List<CarrotObject> currentCarrots = [];
  late PlayerObject player;

  PlayerObject getPlayer() => player;

  Future<void> init() async {
    jsonData = await JsonUtils.read();
    bombs = JsonUtils.extractBomb(jsonData);
    carrots = JsonUtils.extractCarrot(jsonData);
    currentCarrots = carrots;
    if (gameRef.tutorialSkip) {
      await setPlayer();
    }
    gameRef.addAll(bombs);
  }

  Future<void> setPlayer() async {
    player = PlayerObject();
    await add(player);
  }

  void onTick() {
    currentTime++;
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