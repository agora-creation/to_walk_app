import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StepsText extends StatelessWidget {
  final int steps;

  const StepsText({
    this.steps = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: NumberFormat('#,##0').format(steps),
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: '歩/日',
            style: TextStyle(
              color: Colors.black38,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'TsunagiGothic',
            ),
          ),
        ],
      ),
    );
  }
}