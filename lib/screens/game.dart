import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      children: const [
        Card(
          elevation: 8,
          child: ListTile(
            title: Text('とことこキャッチ'),
          ),
        ),
        SizedBox(height: 8),
        Card(
          elevation: 8,
          child: ListTile(
            title: Text('てくてくジャンプ'),
          ),
        ),
      ],
    );
  }
}
