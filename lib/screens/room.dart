import 'package:flutter/material.dart';
import 'package:to_walk_app/widgets/steps_text.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const StepsText(steps: 9999),
        Container(),
        const Text(
          '歩くと何かが起こるかも？',
          style: TextStyle(color: Colors.black38),
        ),
      ],
    );
  }
}
