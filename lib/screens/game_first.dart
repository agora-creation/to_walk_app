import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/first.dart';

class GameFirstScreen extends StatefulWidget {
  const GameFirstScreen({Key? key}) : super(key: key);

  @override
  State<GameFirstScreen> createState() => _GameFirstScreenState();
}

class _GameFirstScreenState extends State<GameFirstScreen> {
  final game = FirstGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}
