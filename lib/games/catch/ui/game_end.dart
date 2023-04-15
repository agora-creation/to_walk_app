import 'package:flutter/material.dart';
import 'package:to_walk_app/games/catch/game.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/screens/home.dart';
import 'package:to_walk_app/widgets/custom_text_button.dart';

class GameEnd extends StatelessWidget {
  final CatchGame game;

  const GameEnd({
    required this.game,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black26,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'ゲーム終了',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '''
                        このゲームでは、画面をタップして、アルクを左右に移動させてください。
                        画面の上部から、スコアアイテムや障害物が降ってきますので、避けたり、キャッチしてください。
                       ''',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextButton(
                          labelText: '戻る',
                          backgroundColor: Colors.grey,
                          onPressed: () => pushReplacementScreen(
                            context,
                            const HomeScreen(index: 2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
