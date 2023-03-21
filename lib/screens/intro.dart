import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/helpers/functions.dart';
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
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFB2EBF2))
      ..loadRequest(Uri.parse('https://www.agora-c.com/alk/terms/'));
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
              titleWidget: Column(
                children: const [
                  Text(
                    'アルク',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- ウォーキング連動育成ゲーム -',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              bodyWidget: Column(
                children: [
                  const SizedBox(height: 80),
                  CustomTextButton(
                    labelText: '既に遊んだことがある場合',
                    backgroundColor: Colors.cyan.shade600,
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => MigrationDialog(
                          userProvider: userProvider,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            PageViewModel(
              title: 'アプリの使い方を説明すると\nユーザーにとって親切だよ!',
              body: '2ページ目だよ!',
              image: Image.asset('assets/images/loading.png'),
            ),
            PageViewModel(
              title: 'あなたの名前を教えてください',
              bodyWidget: Column(
                children: const [
                  Text('name'),
                  Text('name'),
                  Text('name'),
                  Text('name'),
                  Text('name'),
                ],
              ),
            ),
            PageViewModel(
              title: '最後に利用規約に同意してください',
              bodyWidget: SizedBox(
                height: 350,
                child: Scrollbar(
                  controller: ScrollController(),
                  child: WebViewWidget(controller: controller),
                ),
              ),
            ),
          ],
          onDone: () async {
            String? error = await userProvider.signIn();
            if (error != null) return;
            if (!mounted) return;
            pushReplacementScreen(context, const HomeScreen());
          },
          showBackButton: false,
          next: const Icon(Icons.chevron_right),
          back: const Icon(Icons.chevron_left),
          done: const Text(
            '同意する',
            style: TextStyle(color: Colors.white),
          ),
          doneStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.cyan.shade600,
            ),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Colors.cyan.shade600,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
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
                  String? error = await widget.userProvider.signIn();
                  if (error != null) return;
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
