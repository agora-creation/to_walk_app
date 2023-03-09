import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: const [
          Card(
            elevation: 8,
            child: ListTile(
              title: Text('あなたのお名前'),
            ),
          ),
          SizedBox(height: 8),
          Card(
            elevation: 8,
            child: ListTile(
              title: Text('あなたの生年月日'),
            ),
          ),
          SizedBox(height: 8),
          Card(
            elevation: 8,
            child: ListTile(
              title: Text('あなたの身長'),
            ),
          ),
          SizedBox(height: 8),
          Card(
            elevation: 8,
            child: ListTile(
              title: Text('あなたの体重'),
            ),
          ),
          SizedBox(height: 8),
          Card(
            elevation: 8,
            child: ListTile(
              title: Text('このアプリの使い方'),
            ),
          ),
          SizedBox(height: 8),
          Card(
            elevation: 8,
            child: ListTile(
              title: Text('利用規約'),
            ),
          ),
          SizedBox(height: 8),
          Card(
            elevation: 8,
            child: ListTile(
              title: Text('プライバシーポリシー'),
            ),
          ),
          SizedBox(height: 8),
          Card(
            elevation: 8,
            child: ListTile(
              title: Text('お問い合わせ'),
            ),
          ),
        ],
      ),
    );
  }
}
