import 'package:flutter/material.dart';
import 'package:to_walk_app/games/jumping/high_scores.dart';
import 'package:to_walk_app/widgets/my_button.dart';
import 'package:to_walk_app/widgets/my_text.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constrains) {
                  return Stack(
                    children: [
                      Positioned(
                        bottom: constrains.maxHeight * .25,
                        child: Image.asset(
                          'assets/images/heroJump.png',
                          scale: 1.25,
                        ),
                      ),
                      Positioned(
                        bottom: constrains.maxHeight * .6,
                        child: Image.asset(
                          'assets/images/LandPiece_DarkMulticolored.png',
                          scale: 1.25,
                        ),
                      ),
                      Positioned(
                        bottom: constrains.maxHeight * .05,
                        left: constrains.maxWidth * .2,
                        child: Image.asset(
                          'assets/images/BrokenLandPiece_Beige.png',
                          scale: 1.25,
                        ),
                      ),
                      Positioned(
                        bottom: constrains.maxHeight * .3,
                        right: 0,
                        child: Image.asset(
                          'assets/images/LandPiece_DarkBlue.png',
                          scale: 1.5,
                        ),
                      ),
                      Positioned(
                        top: constrains.maxHeight * .3,
                        right: 0,
                        child: Image.asset(
                          'assets/images/HappyCloud.png',
                          scale: 1.75,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Image.asset('assets/images/title.png'),
                          MyText(
                            text: 'ベストスコア: ${HighScores.highScores[0]}',
                            fontSize: 26,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyButton(
                                  text: '遊ぶ',
                                  onPressed: () {},
                                ),
                                const SizedBox(height: 40),
                                MyButton(
                                  text: 'レート',
                                  onPressed: () {},
                                ),
                                const SizedBox(height: 40),
                                MyButton(
                                  text: 'ダッシュボード',
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
