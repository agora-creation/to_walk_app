import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/fourth.dart';

class GameFourthScreen extends StatefulWidget {
  const GameFourthScreen({Key? key}) : super(key: key);

  @override
  State<GameFourthScreen> createState() => _GameFourthScreenState();
}

class _GameFourthScreenState extends State<GameFourthScreen> {
  final game = FourthGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}
