import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/games/jump/game.dart';
import 'package:to_walk_app/games/scores.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/models/user_alk.dart';
import 'package:to_walk_app/providers/user.dart';
import 'package:to_walk_app/widgets/game_list_tile.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  void _init() async {
    await Scores.load();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    UserAlkModel? alk = userProvider.alk;
    int level = alk?.level ?? 0;

    return SafeArea(
      child: level >= 1
          ? ListView(
              padding: const EdgeInsets.all(8),
              children: [
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'アルクのLvが上がると、ゲームに変化があるかも？',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GameListTile(
                  labelText: 'てくてくキャッチ！',
                  scoreText: '${Scores.data['catchScore']}本',
                  onTap: () => pushReplacementScreen(
                    context,
                    const CatchGameWidget(),
                  ),
                ),
                const SizedBox(height: 8),
                GameListTile(
                  labelText: 'ぱたぱたジャンプ！',
                  scoreText: '${Scores.data['jumpScore']}m',
                  onTap: () => pushReplacementScreen(
                    context,
                    const JumpGameWidget(),
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'タマゴを孵化させると',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '遊べるようになるよ！',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
