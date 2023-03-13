import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/models/user.dart';
import 'package:to_walk_app/providers/user.dart';
import 'package:to_walk_app/screens/user_birth.dart';
import 'package:to_walk_app/widgets/custom_text_button.dart';
import 'package:to_walk_app/widgets/custom_text_form_field.dart';
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
    final userProvider = Provider.of<UserProvider>(context);
    UserModel? user = userProvider.user;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          SettingCard(
            labelText: 'あなたの情報を登録してください',
            children: [
              SettingListTile(
                labelText: '名前',
                value: user?.name ?? '',
                onTap: () {
                  TextEditingController name = TextEditingController();
                  name.text = user?.name ?? '';
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('名前'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(
                            controller: name,
                            obscureText: false,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomTextButton(
                                labelText: '登録する',
                                backgroundColor: Colors.blue,
                                onPressed: () async {
                                  String? error =
                                      await userProvider.updateName(name.text);
                                  if (error != null) return;
                                  await userProvider.reload();
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SettingListTile(
                labelText: '生年月日',
                value: 'test',
                onTap: () => pushScreen(context, const UserBirthScreen()),
              ),
              SettingListTile(
                labelText: '性別',
                value: 'test',
                onTap: () {},
              ),
              SettingListTile(
                labelText: '居住都道府県',
                value: 'test',
                onTap: () {},
              ),
              SettingListTile(
                labelText: '身長',
                value: 'test',
                onTap: () {},
              ),
              SettingListTile(
                labelText: '体重',
                value: 'test',
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
                onTap: () {},
              ),
              SettingListTile(
                labelText: '利用規約',
                onTap: () {},
              ),
              SettingListTile(
                labelText: 'プライバシーポリシー',
                onTap: () {},
              ),
              SettingListTile(
                labelText: 'お問い合わせ',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
