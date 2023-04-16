import 'package:flame/components.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/games/catch/json_utils.dart';
import 'package:to_walk_app/games/catch/objects/player.dart';

class GameController extends Component with HasGameRef<CatchGame> {
  int score = 0;
  late dynamic jsonData;
  late PlayerObject player;

  PlayerObject getPlayer() => player;

  Future<void> init() async {
    jsonData = await JsonUtils.read();

    //JSON

    player = PlayerObject();
    await add(player);
  }
}
