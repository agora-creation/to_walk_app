import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/models/user.dart';
import 'package:to_walk_app/providers/user.dart';
import 'package:to_walk_app/screens/intro.dart';
import 'package:to_walk_app/screens/privacy_policy.dart';
import 'package:to_walk_app/screens/terms.dart';
import 'package:to_walk_app/widgets/custom_text_button.dart';
import 'package:to_walk_app/widgets/custom_text_form_field.dart';
import 'package:to_walk_app/widgets/link_text.dart';
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
                  showDialog(
                    context: context,
                    builder: (_) => NameDialog(userProvider: userProvider),
                  );
                },
              ),
              SettingListTile(
                labelText: '生年月日',
                value: '$birthText ($age)',
                onTap: () async {
                  DateTime? currentTime;
                  if (birthDate != '') {
                    currentTime = DateTime.parse(birthDate);
                  }
                  await DatePicker.showDatePicker(
                    context,
                    locale: LocaleType.jp,
                    currentTime: currentTime,
                    minTime: DateTime.now().subtract(
                      const Duration(days: 365 * 100),
                    ),
                    maxTime: DateTime.now().subtract(
                      const Duration(days: 365 * 10),
                    ),
                    onConfirm: (date) async {
                      String? error = await userProvider.updateBirthDate(
                        dateText('yyyy-MM-dd', date),
                      );
                      if (error != null) return;
                      await userProvider.reload();
                    },
                    // theme: const DatePickerTheme(
                    //   cancelStyle: TextStyle(fontFamily: 'TsunagiGothic'),
                    //   doneStyle: TextStyle(fontFamily: 'TsunagiGothic'),
                    //   itemStyle: TextStyle(fontFamily: 'TsunagiGothic'),
                    // ),
                  );
                },
              ),
              SettingListTile(
                labelText: '性別',
                value: user?.gender ?? '',
                onTap: () {
                  // BottomPicker(
                  //   items: genderList,
                  //   title: '性別',
                  //   onSubmit: (index) async {
                  //     String gender = genderList[index].data ?? '';
                  //     String? error = await userProvider.updateGender(gender);
                  //     if (error != null) return;
                  //     await userProvider.reload();
                  //   },
                  //   buttonText: '登録する',
                  //   buttonTextStyle: const TextStyle(color: Colors.white),
                  //   buttonSingleColor: Colors.blue,
                  //   displayButtonIcon: false,
                  //   dismissable: true,
                  //   pickerTextStyle: const TextStyle(
                  //     color: Color(0xFF333333),
                  //     fontSize: 16,
                  //     fontFamily: 'TsunagiGothic',
                  //   ),
                  // ).show(context);
                },
              ),
              SettingListTile(
                labelText: '居住都道府県',
                value: user?.prefecture ?? '',
                onTap: () {
                  // BottomPicker(
                  //   items: prefectureList,
                  //   title: '居住都道府県',
                  //   onSubmit: (index) async {
                  //     String prefecture = prefectureList[index].data ?? '';
                  //     String? error = await userProvider.updatePrefecture(
                  //       prefecture,
                  //     );
                  //     if (error != null) return;
                  //     await userProvider.reload();
                  //   },
                  //   buttonText: '登録する',
                  //   buttonTextStyle: const TextStyle(color: Colors.white),
                  //   buttonSingleColor: Colors.blue,
                  //   displayButtonIcon: false,
                  //   dismissable: true,
                  //   pickerTextStyle: const TextStyle(
                  //     color: Color(0xFF333333),
                  //     fontSize: 16,
                  //     fontFamily: 'TsunagiGothic',
                  //   ),
                  // ).show(context);
                },
              ),
              SettingListTile(
                labelText: '身長',
                value: '${user?.bodyHeight.toString()} cm',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => BodyHeightDialog(
                      userProvider: userProvider,
                    ),
                  );
                },
              ),
              SettingListTile(
                labelText: '体重',
                value: '${user?.bodyWeight.toString()} kg',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => BodyWeightDialog(
                      userProvider: userProvider,
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
              // SettingListTile(
              //   labelText: '使い方・遊び方',
              //   onTap: () => pushScreen(context, const HowToScreen()),
              // ),
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
          // const SizedBox(height: 8),
          // SettingCard(
          //   labelText: 'データを引き継ぐ',
          //   children: [
          //     SettingListTile(
          //       labelText: '引き継ぎ用のコードを発行',
          //       onTap: () => pushScreen(context, const MigrationScreen()),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 24),
          Center(
            child: LinkText(
              labelText: '全てのデータをリセット',
              labelColor: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '全てのデータをリセットし、アプリを初期化します。よろしいですか？',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextButton(
                              labelText: 'キャンセル',
                              backgroundColor: Colors.grey,
                              onPressed: () => Navigator.pop(context),
                            ),
                            CustomTextButton(
                              labelText: 'はい',
                              backgroundColor: Colors.red,
                              onPressed: () async {
                                await userProvider.signOut();
                                await allRemovePrefs();
                                if (!mounted) return;
                                pushReplacementScreen(
                                  context,
                                  const IntroScreen(),
                                );
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
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class NameDialog extends StatefulWidget {
  final UserProvider userProvider;

  const NameDialog({
    required this.userProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<NameDialog> {
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.userProvider.user?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                  String? error = await widget.userProvider.updateName(
                    name.text,
                  );
                  if (error != null) return;
                  await widget.userProvider.reload();
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BodyHeightDialog extends StatefulWidget {
  final UserProvider userProvider;

  const BodyHeightDialog({
    required this.userProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<BodyHeightDialog> createState() => _BodyHeightDialogState();
}

class _BodyHeightDialogState extends State<BodyHeightDialog> {
  TextEditingController bodyHeight = TextEditingController();

  @override
  void initState() {
    super.initState();
    bodyHeight.text = widget.userProvider.user?.bodyHeight.toString() ?? '0';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                  String? error = await widget.userProvider.updateBodyHeight(
                    double.parse(bodyHeight.text),
                  );
                  if (error != null) return;
                  await widget.userProvider.reload();
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BodyWeightDialog extends StatefulWidget {
  final UserProvider userProvider;

  const BodyWeightDialog({
    required this.userProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<BodyWeightDialog> createState() => _BodyWeightDialogState();
}

class _BodyWeightDialogState extends State<BodyWeightDialog> {
  TextEditingController bodyWeight = TextEditingController();

  @override
  void initState() {
    super.initState();
    bodyWeight.text = widget.userProvider.user?.bodyWeight.toString() ?? '0';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                  String? error = await widget.userProvider.updateBodyWeight(
                    double.parse(bodyWeight.text),
                  );
                  if (error != null) return;
                  await widget.userProvider.reload();
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
