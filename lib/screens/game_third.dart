import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/third.dart';

class GameThirdScreen extends StatefulWidget {
  const GameThirdScreen({Key? key}) : super(key: key);

  @override
  State<GameThirdScreen> createState() => _GameThirdScreenState();
}

class _GameThirdScreenState extends State<GameThirdScreen> {
  final game = ThirdGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}
