import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final double? fontSize;

  const MyText({
    required this.text,
    required this.fontSize,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 28,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'TsunagiGothic',
      ),
    );
  }
}
