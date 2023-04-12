import 'package:flutter/material.dart';
import 'package:to_walk_app/games/jumping/game.dart';
import 'package:to_walk_app/widgets/my_button.dart';
import 'package:to_walk_app/widgets/my_text.dart';

class PauseMenu extends StatelessWidget {
  final JumpingGame game;

  const PauseMenu({
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
                  text: 'ポーズ',
                  fontSize: 56,
                ),
                const SizedBox(height: 40),
                MyButton(
                  text: '再開',
                  onPressed: () {
                    game.overlays.remove('PauseMenu');
                    game.paused = false;
                  },
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
