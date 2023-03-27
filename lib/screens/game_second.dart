import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/second.dart';

class GameSecondScreen extends StatefulWidget {
  const GameSecondScreen({Key? key}) : super(key: key);

  @override
  State<GameSecondScreen> createState() => _GameSecondScreenState();
}

class _GameSecondScreenState extends State<GameSecondScreen> {
  final game = SecondGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}
