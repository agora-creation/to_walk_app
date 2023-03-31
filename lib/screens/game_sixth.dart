import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/sixth.dart';

class GameSixthScreen extends StatefulWidget {
  const GameSixthScreen({Key? key}) : super(key: key);

  @override
  State<GameSixthScreen> createState() => _GameSixthScreenState();
}

class _GameSixthScreenState extends State<GameSixthScreen> {
  final game = SixthGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}
