import 'package:flutter/material.dart';

class HowToScreen extends StatefulWidget {
  const HowToScreen({Key? key}) : super(key: key);

  @override
  State<HowToScreen> createState() => _HowToScreenState();
}

class _HowToScreenState extends State<HowToScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2EBF2),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text('使い方・遊び方'),
      ),
    );
  }
}
