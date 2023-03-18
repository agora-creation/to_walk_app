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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            elevation: 8,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Text(
                  '①とにかく歩こう！',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Divider(),
                Text(
                  '②何歩歩いたか確認しよう！',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Divider(),
                Text(
                  '③タマゴを孵化させよう！',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Divider(),
                Text(
                  '④アルクを成長させよう！',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Divider(),
                Text(
                  '⑤ミニゲームで遊ぼう！',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
