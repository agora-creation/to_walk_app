import 'package:flutter/material.dart';
import 'package:to_walk_app/widgets/setting_card.dart';

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
        children: [
          SettingCard(
            labelText: '個人情報の登録',
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                ),
                child: ListTile(
                  title: Text('あなたの名前'),
                  trailing: Icon(
                    Icons.edit_rounded,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              ListTile(title: Text('あなたの生年月日')),
              ListTile(title: Text('あなたの性別')),
              ListTile(title: Text('あなたの居住都道府県')),
              ListTile(title: Text('あなたの身長')),
              ListTile(title: Text('あなたの体重')),
            ],
          ),
          SizedBox(height: 8),
          SettingCard(
            labelText: 'このアプリについて',
            children: [
              ListTile(title: Text('使い方・遊び方')),
              ListTile(title: Text('利用規約')),
              ListTile(title: Text('プライバシーポリシー')),
              ListTile(title: Text('お問い合わせ')),
            ],
          ),
        ],
      ),
    );
  }
}
