import 'package:flutter/material.dart';
import 'package:to_walk_app/games/jump/game.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/screens/home.dart';
import 'package:to_walk_app/widgets/custom_text_button.dart';

class JumpGameStart extends StatelessWidget {
  final JumpGame game;

  const JumpGameStart({
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
                        'ぱたぱたジャンプ！',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '① 画面をタップすると、アルクが一度だけジャンプします。',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      '② 何もしないと、アルクが下に落ちてしまうので、タップし続けましょう。',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextButton(
                          labelText: '戻る',
                          backgroundColor: Colors.grey,
                          onPressed: () => pushReplacementScreen(
                            context,
                            const HomeScreen(index: 2),
                          ),
                        ),
                        CustomTextButton(
                          labelText: '始める！',
                          backgroundColor: Colors.blue,
                          onPressed: () async {
                            game.overlays.remove('GameStart');
                            game.paused = false;
                            await game.controller.setPlayer();
                          },
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
