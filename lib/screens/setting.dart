import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/models/user.dart';
import 'package:to_walk_app/providers/user.dart';
import 'package:to_walk_app/widgets/custom_number_picker.dart';
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
    String birthDate = user?.birthDate ?? '';
    String birthText = '----年--月--日';
    String age = '--歳';
    if (birthDate != '') {
      DateTime dateTime = DateTime.parse(birthDate);
      birthText = dateText('yyyy年MM月dd日', dateTime);
      age = '${AgeCalculator.age(dateTime).years.toString()}歳';
    }

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
                value: '$birthText ($age)',
                onTap: () async {
                  await DatePicker.showDatePicker(
                    context,
                    locale: LocaleType.jp,
                    currentTime: DateTime.parse(birthDate),
                    minTime: DateTime.now().subtract(
                      const Duration(days: 365 * 100),
                    ),
                    maxTime: DateTime.now().subtract(
                      const Duration(days: 365 * 10),
                    ),
                    onConfirm: (date) async {
                      String? error = await userProvider
                          .updateBirthDate(dateText('yyyy-MM-dd', date));
                      if (error != null) return;
                      await userProvider.reload();
                    },
                  );
                },
              ),
              SettingListTile(
                labelText: '性別',
                value: user?.gender ?? '',
                onTap: () {},
              ),
              SettingListTile(
                labelText: '居住都道府県',
                value: user?.prefecture ?? '',
                onTap: () {},
              ),
              SettingListTile(
                labelText: '身長',
                value: '${user?.bodyHeight.toString()} cm',
                onTap: () {
                  int bodyHeight = user?.bodyHeight.round() ?? 0;
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('身長'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomNumberPicker(
                            minValue: 0,
                            maxValue: 200,
                            value: bodyHeight,
                            onChanged: (value) {
                              setState(() => bodyHeight = value);
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomTextButton(
                                labelText: '登録する',
                                backgroundColor: Colors.blue,
                                onPressed: () async {
                                  String? error = await userProvider
                                      .updateBodyHeight(bodyHeight);
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
                labelText: '体重',
                value: '${user?.bodyWeight.toString()} kg',
                onTap: () {
                  int bodyWeight = user?.bodyWeight.round() ?? 0;
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('体重'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomNumberPicker(
                            minValue: 0,
                            maxValue: 200,
                            value: bodyWeight,
                            onChanged: (value) {
                              setState(() => bodyWeight = value);
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomTextButton(
                                labelText: '登録する',
                                backgroundColor: Colors.blue,
                                onPressed: () async {
                                  String? error = await userProvider
                                      .updateBodyWeight(bodyWeight);
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
