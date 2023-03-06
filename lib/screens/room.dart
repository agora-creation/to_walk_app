import 'package:flutter/material.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/widgets/steps_text.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  int steps = 0;

  void _init() async {
    int prefSteps = await getPrefsInt('steps') ?? 0;
    setState(() => steps = prefSteps);
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StepsText(steps: steps),
        Container(),
        const Text(
          '歩くと何かが起こるかも？',
          style: TextStyle(color: Colors.black38),
        ),
      ],
    );
  }
}
