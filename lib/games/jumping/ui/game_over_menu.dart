import 'package:flutter/material.dart';
import 'package:to_walk_app/games/jumping/game.dart';
import 'package:to_walk_app/games/jumping/high_scores.dart';
import 'package:to_walk_app/widgets/my_button.dart';
import 'package:to_walk_app/widgets/my_text.dart';

class GameOverMenu extends StatelessWidget {
  final JumpingGame game;

  const GameOverMenu({
    required this.game,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.black38,
      child: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: height * .15),
                const MyText(
                  text: 'ゲームオーバー！',
                  fontSize: 56,
                ),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(.2),
                    1: FlexColumnWidth(.5),
                    2: FlexColumnWidth(.2),
                    3: FlexColumnWidth(.1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const SizedBox(),
                        const MyText(
                          text: 'スコア',
                          fontSize: 28,
                        ),
                        MyText(
                          text: game.score.toString(),
                          fontSize: 28,
                        ),
                        const SizedBox(),
                      ],
                    ),
                    TableRow(
                      children: [
                        const SizedBox(),
                        const MyText(
                          text: 'ベストスコア',
                          fontSize: 28,
                        ),
                        MyText(
                          text: '${HighScores.highScores[0]}',
                          fontSize: 28,
                        ),
                        const SizedBox(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                MyButton(
                  text: 'もう一度',
                  onPressed: () {},
                ),
                const SizedBox(height: 40),
                MyButton(
                  text: 'メニュー',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
