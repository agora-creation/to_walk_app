import 'package:flutter/material.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/screens/user_birth.dart';
import 'package:to_walk_app/screens/user_name.dart';
import 'package:to_walk_app/widgets/setting_card.dart';
import 'package:to_walk_app/widgets/setting_list_tile.dart';

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
              SettingListTile(
                labelText: 'あなたの名前',
                iconData: Icons.edit_rounded,
                onTap: () => pushScreen(context, const UserNameScreen()),
              ),
              SettingListTile(
                labelText: 'あなたの生年月日',
                iconData: Icons.edit_rounded,
                onTap: () => pushScreen(context, const UserBirthScreen()),
              ),
              SettingListTile(
                labelText: 'あなたの性別',
                iconData: Icons.edit_rounded,
                onTap: () {},
              ),
              SettingListTile(
                labelText: 'あなたの居住都道府県',
                iconData: Icons.edit_rounded,
                onTap: () {},
              ),
              SettingListTile(
                labelText: 'あなたの身長',
                iconData: Icons.edit_rounded,
                onTap: () {},
              ),
              SettingListTile(
                labelText: 'あなたの体重',
                iconData: Icons.edit_rounded,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          SettingCard(
            labelText: 'このアプリについて',
            children: [
              SettingListTile(
                labelText: '使い方・遊び方',
                iconData: Icons.chevron_right,
                onTap: () {},
              ),
              SettingListTile(
                labelText: '利用規約',
                iconData: Icons.chevron_right,
                onTap: () {},
              ),
              SettingListTile(
                labelText: 'プライバシーポリシー',
                iconData: Icons.chevron_right,
                onTap: () {},
              ),
              SettingListTile(
                labelText: 'お問い合わせ',
                iconData: Icons.chevron_right,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
