import 'package:age_calculator/age_calculator.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/helpers/style.dart';
import 'package:to_walk_app/models/user.dart';
import 'package:to_walk_app/providers/user.dart';
import 'package:to_walk_app/screens/how_to.dart';
import 'package:to_walk_app/screens/migration.dart';
import 'package:to_walk_app/screens/privacy_policy.dart';
import 'package:to_walk_app/screens/terms.dart';
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
  String version = '';

  void _init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

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
    String bmiText = calculationBMI(
      user?.bodyHeight ?? 0.0,
      user?.bodyWeight ?? 0.0,
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          SettingCard(
            labelText: 'あなたの情報',
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
                    theme: const DatePickerTheme(
                      cancelStyle: TextStyle(fontFamily: 'TsunagiGothic'),
                      doneStyle: TextStyle(fontFamily: 'TsunagiGothic'),
                      itemStyle: TextStyle(fontFamily: 'TsunagiGothic'),
                    ),
                  );
                },
              ),
              SettingListTile(
                labelText: '性別',
                value: user?.gender ?? '',
                onTap: () {
                  BottomPicker(
                    items: genderList,
                    title: '性別',
                    onSubmit: (index) async {
                      String gender = genderList[index].data ?? '';
                      String? error = await userProvider.updateGender(gender);
                      if (error != null) return;
                      await userProvider.reload();
                    },
                    buttonText: '登録する',
                    buttonTextStyle: const TextStyle(color: Colors.white),
                    buttonSingleColor: Colors.blue,
                    displayButtonIcon: false,
                    dismissable: true,
                    pickerTextStyle: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontFamily: 'TsunagiGothic',
                    ),
                  ).show(context);
                },
              ),
              SettingListTile(
                labelText: '居住都道府県',
                value: user?.prefecture ?? '',
                onTap: () {
                  BottomPicker(
                    items: prefectureList,
                    title: '居住都道府県',
                    onSubmit: (index) async {
                      String prefecture = prefectureList[index].data ?? '';
                      String? error =
                          await userProvider.updatePrefecture(prefecture);
                      if (error != null) return;
                      await userProvider.reload();
                    },
                    buttonText: '登録する',
                    buttonTextStyle: const TextStyle(color: Colors.white),
                    buttonSingleColor: Colors.blue,
                    displayButtonIcon: false,
                    dismissable: true,
                    pickerTextStyle: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontFamily: 'TsunagiGothic',
                    ),
                  ).show(context);
                },
              ),
              SettingListTile(
                labelText: '身長',
                value: '${user?.bodyHeight.toString()} cm',
                onTap: () {
                  TextEditingController bodyHeight = TextEditingController();
                  bodyHeight.text = user?.bodyHeight.toString() ?? '0';
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('身長'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(
                            controller: bodyHeight,
                            obscureText: false,
                            keyboardType: TextInputType.number,
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
                                      await userProvider.updateBodyHeight(
                                          int.parse(bodyHeight.text));
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
                  TextEditingController bodyWeight = TextEditingController();
                  bodyWeight.text = user?.bodyWeight.toString() ?? '0';
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('体重'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(
                            controller: bodyWeight,
                            obscureText: false,
                            keyboardType: TextInputType.number,
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
                                      await userProvider.updateBodyWeight(
                                          int.parse(bodyWeight.text));
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
                labelText: 'BMI',
                value: bmiText,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SettingCard(
            labelText: 'このアプリについて',
            children: [
              SettingListTile(
                labelText: '使い方・遊び方',
                onTap: () => pushScreen(context, const HowToScreen()),
              ),
              SettingListTile(
                labelText: '利用規約',
                onTap: () => pushScreen(context, const TermsScreen()),
              ),
              SettingListTile(
                labelText: 'プライバシーポリシー',
                onTap: () => pushScreen(context, const PrivacyPolicyScreen()),
              ),
              SettingListTile(
                labelText: 'バージョン',
                value: version,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SettingCard(
            labelText: 'データを引き継ぐ',
            children: [
              SettingListTile(
                labelText: '引き継ぎ用のコードを発行',
                onTap: () => pushScreen(context, const MigrationScreen()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
