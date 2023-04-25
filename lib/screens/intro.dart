import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/helpers/style.dart';
import 'package:to_walk_app/providers/user.dart';
import 'package:to_walk_app/screens/home.dart';
import 'package:to_walk_app/widgets/custom_text_button.dart';
import 'package:to_walk_app/widgets/custom_text_form_field.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController bodyHeight = TextEditingController();
  TextEditingController bodyWeight = TextEditingController();

  @override
  void initState() {
    super.initState();
    bodyHeight.text = '0';
    bodyWeight.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          scrollPhysics: const BouncingScrollPhysics(),
          pages: [
            PageViewModel(
              image: Image.asset('assets/images/loading.png'),
              title: 'アプリを開かなくても\n持ち歩くだけで歩数が計測できる！',
              body: '毎日の計測した歩数はカレンダー形式で見ることができます。',
            ),
            PageViewModel(
              title: 'あなたの情報を教えてください',
              bodyWidget: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '※未入力でも可',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '名前',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CustomTextFormField(
                        controller: name,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '身長 (cm)',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CustomTextFormField(
                        controller: bodyHeight,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '体重 (kg)',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CustomTextFormField(
                        controller: bodyWeight,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
          onDone: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => TermsDialog(
                userProvider: userProvider,
                name: name.text,
                bodyHeight: int.parse(bodyHeight.text),
                bodyWeight: int.parse(bodyWeight.text),
              ),
            );
          },
          showBackButton: false,
          next: const Icon(Icons.chevron_right),
          back: const Icon(Icons.chevron_left),
          done: const Text(
            'はじめる',
            style: TextStyle(color: Colors.white),
          ),
          doneStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.cyan.shade600,
            ),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10),
            activeSize: const Size(20, 10),
            activeColor: Colors.cyan.shade600,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    );
  }
}

class MigrationDialog extends StatefulWidget {
  final UserProvider userProvider;

  const MigrationDialog({
    required this.userProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<MigrationDialog> createState() => _MigrationDialogState();
}

class _MigrationDialogState extends State<MigrationDialog> {
  TextEditingController code = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'このアプリを別のスマートフォンで遊んだことがある場合、データを引き継いで始めることが可能です。',
            ),
            const SizedBox(height: 4),
            const Text(
              '別のスマートフォンでこのアプリを開いて、引き継ぎ用のコードをメモしていただき、以下に入力してください。',
            ),
            const SizedBox(height: 4),
            errorText != null
                ? Text(
                    errorText ?? '',
                    style: const TextStyle(color: Colors.red),
                  )
                : Container(),
            const SizedBox(height: 16),
            const Text(
              '引き継ぎ用のコード',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              controller: code,
              obscureText: false,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextButton(
                  labelText: 'やめる',
                  backgroundColor: Colors.grey,
                  onPressed: () => Navigator.pop(context),
                ),
                CustomTextButton(
                  labelText: '引き継いで始める',
                  backgroundColor: Colors.cyan.shade600,
                  onPressed: () async {
                    String? error = await widget.userProvider.signInMigration(
                      code: code.text.trim(),
                    );
                    if (error != null) {
                      setState(() => errorText = error);
                      return;
                    }
                    if (!mounted) return;
                    pushReplacementScreen(context, const HomeScreen());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TermsDialog extends StatefulWidget {
  final UserProvider userProvider;
  final String name;
  final int bodyHeight;
  final int bodyWeight;

  const TermsDialog({
    required this.userProvider,
    this.name = '',
    this.bodyHeight = 0,
    this.bodyWeight = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<TermsDialog> createState() => _TermsDialogState();
}

class _TermsDialogState extends State<TermsDialog> {
  late final WebViewController controller;
  String? errorText;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFB2EBF2))
      ..loadRequest(Uri.parse(termsUseUrl));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('利用規約')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '以下の利用規約をご確認の上、「同意する」ボタンをタップしてください。',
          ),
          const SizedBox(height: 4),
          errorText != null
              ? Text(
                  errorText ?? '',
                  style: const TextStyle(color: Colors.red),
                )
              : Container(),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: Scrollbar(
              controller: ScrollController(),
              child: WebViewWidget(controller: controller),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextButton(
                labelText: '同意しない',
                backgroundColor: Colors.grey,
                onPressed: () => Navigator.pop(context),
              ),
              CustomTextButton(
                labelText: '同意する',
                backgroundColor: Colors.cyan.shade600,
                onPressed: () async {
                  String? error = await widget.userProvider.signIn(
                    name: widget.name,
                    bodyHeight: widget.bodyHeight,
                    bodyWeight: widget.bodyWeight,
                  );
                  if (error != null) {
                    setState(() => errorText = error);
                    return;
                  }
                  if (!mounted) return;
                  pushReplacementScreen(context, const HomeScreen());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
