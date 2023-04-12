import 'package:flutter/material.dart';
import 'package:to_walk_app/games/jumping/high_scores.dart';
import 'package:to_walk_app/widgets/my_text.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacing = MediaQuery.of(context).size.height * .075;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/images/ui/buttonBack.png'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 16),
                    const MyText(
                      text: 'ベストスコア',
                      fontSize: 42,
                    ),
                    SizedBox(height: spacing),
                    MyText(
                      text: '${HighScores.highScores[0]}',
                      fontSize: 30,
                    ),
                    SizedBox(height: spacing),
                    MyText(
                      text: '${HighScores.highScores[1]}',
                      fontSize: 30,
                    ),
                    SizedBox(height: spacing),
                    MyText(
                      text: '${HighScores.highScores[2]}',
                      fontSize: 30,
                    ),
                    SizedBox(height: spacing),
                    MyText(
                      text: '${HighScores.highScores[3]}',
                      fontSize: 30,
                    ),
                    SizedBox(height: spacing),
                    MyText(
                      text: '${HighScores.highScores[4]}',
                      fontSize: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
