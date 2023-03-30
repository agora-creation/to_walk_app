import 'package:flutter/material.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/screens/game_first.dart';
import 'package:to_walk_app/screens/game_fourth.dart';
import 'package:to_walk_app/screens/game_second.dart';
import 'package:to_walk_app/screens/game_third.dart';
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
            labelText: 'ゲーム1',
            onTap: () => pushScreen(context, const GameFirstScreen()),
          ),
          GameListTile(
            labelText: 'ゲーム2',
            onTap: () => pushScreen(context, const GameSecondScreen()),
          ),
          GameListTile(
            labelText: 'ゲーム3',
            onTap: () => pushScreen(context, const GameThirdScreen()),
          ),
          GameListTile(
            labelText: 'ゲーム4',
            onTap: () => pushScreen(context, const GameFourthScreen()),
          ),
        ],
      ),
    );
  }
}
