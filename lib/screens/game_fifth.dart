import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/fifth.dart';

class GameFifthScreen extends StatefulWidget {
  const GameFifthScreen({Key? key}) : super(key: key);

  @override
  State<GameFifthScreen> createState() => _GameFifthScreenState();
}

class _GameFifthScreenState extends State<GameFifthScreen> {
  final game = FifthGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}
