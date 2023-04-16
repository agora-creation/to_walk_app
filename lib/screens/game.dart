import 'package:flutter/material.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/games/scores.dart';
import 'package:to_walk_app/helpers/functions.dart';
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
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const SizedBox(height: 8),
          GameListTile(
            labelText: 'てくてくキャッチ',
            scoreText: '${Scores.data['catchScore']}',
            onTap: () => pushReplacementScreen(
              context,
              const CatchGameWidget(),
            ),
          ),
          const SizedBox(height: 8),
          GameListTile(
            labelText: 'だだだダッシュ！',
            scoreText: '0m',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          GameListTile(
            labelText: 'ぱたぱたジャンプ！',
            scoreText: '0m',
            onTap: () {},
          ),
          // GameListTile(
          //   labelText: 'シューティングゲーム',
          //   onTap: () => pushScreen(context, const ShootingGameScreen()),
          // ),
          // GameListTile(
          //   labelText: '走ってジャンプする',
          //   onTap: () {},
          // ),
          // GameListTile(
          //   labelText: '飛び続ける',
          //   onTap: () {},
          // ),
          // GameListTile(
          //   labelText: 'Lesson 01',
          //   onTap: () => pushScreen(context, const Lesson01GameScreen()),
          // ),
          // GameListTile(
          //   labelText: 'ジャンプ！ジャンプ！',
          //   onTap: () => pushReplacementScreen(
          //     context,
          //     const JumpingGameWidget(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
