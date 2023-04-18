import 'package:flame/components.dart';
import 'package:to_walk_app/games/json_utils.dart';
import 'package:to_walk_app/games/jump/game.dart';
import 'package:to_walk_app/games/jump/objects/cloud.dart';
import 'package:to_walk_app/games/jump/objects/player.dart';
import 'package:to_walk_app/games/scores.dart';

class JumpGameController extends Component with HasGameRef<JumpGame> {
  int score = 0;
  int currentTime = 0;
  late dynamic jsonData;
  late List<CloudObject> clouds;
  late PlayerObject player;

  PlayerObject getPlayer() => player;

  Future<void> init() async {
    jsonData = await JsonUtils.readJump();
    clouds = JsonUtils.extractCloud(jsonData);
    if (gameRef.tutorialSkip) {
      await setPlayer();
    }
  }

  Future<void> setPlayer() async {
    player = PlayerObject();
    await add(player);
  }

  void onTick() {
    score++;
    currentTime++;
    for (final cloud in clouds) {
      if (cloud.time == currentTime) {
        gameRef.add(cloud);
      }
    }
  }

  void gameFinish() async {
    player.dead();
    gameRef.timer.removeOnFinish;
    await Future.delayed(const Duration(seconds: 1));
    findGame()?.overlays.add('GameEnd');
    findGame()?.paused = true;
    Scores.jumpSave(score);
  }
}
