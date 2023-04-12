import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/widgets/my_text.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MyButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpriteButton.asset(
      path: 'ui/button.png',
      pressedPath: 'ui/button.png',
      onPressed: onPressed,
      height: 50,
      width: 120,
      label: MyText(
        text: text,
        fontSize: 26,
      ),
    );
  }
}
