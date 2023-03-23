import 'package:flutter/material.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/screens/game_first.dart';

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
          GestureDetector(
            onTap: () => pushScreen(context, const GameFirstScreen()),
            child: const Card(
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ListTile(
                  title: Text('とことこキャッチ'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
