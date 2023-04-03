import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/game.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/widgets/game_list_tile.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          GameListTile(
            labelText: 'シューティングゲーム',
            onTap: () => pushScreen(context, const ShootingGameScreen()),
          ),
        ],
      ),
    );
  }
}
