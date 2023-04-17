import 'package:flutter/material.dart';
import 'package:to_walk_app/games/jump/game.dart';
import 'package:to_walk_app/games/scores.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/helpers/style.dart';
import 'package:to_walk_app/screens/home.dart';
import 'package:to_walk_app/widgets/custom_text_button.dart';

class JumpGameEnd extends StatelessWidget {
  final JumpGame game;

  const JumpGameEnd({
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
                        'ゲーム結果',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: kTopBottomBorder,
                      child: ListTile(
                        title: const Text('今回のスコア'),
                        trailing: Text('${game.controller.score}'),
                      ),
                    ),
                    Container(
                      decoration: kBottomBorder,
                      child: ListTile(
                        title: const Text('ベストスコア'),
                        trailing: Text('${Scores.data['jumpScore']}'),
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
                          labelText: 'もう一度！',
                          backgroundColor: Colors.blue,
                          onPressed: () => pushReplacementScreen(
                            context,
                            const JumpGameWidget(tutorialSkip: true),
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
