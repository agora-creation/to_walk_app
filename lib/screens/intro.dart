import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/providers/user.dart';
import 'package:to_walk_app/screens/home.dart';
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
              bodyWidget: TextButton(
                onPressed: () {},
                child: const Text('引き継ぐ'),
              ),
            ),
            PageViewModel(
              title: 'アプリの使い方を説明すると\nユーザーにとって親切だよ!',
              body: '2ページ目だよ!',
              image: Image.asset('assets/images/loading.png'),
            ),
            PageViewModel(
              title: 'あなたの情報を教えてください',
              body: '3ページ目だよ!',
            ),
            PageViewModel(
              title: '最後に利用規約に同意してください',
              bodyWidget: WebViewWidget(controller: controller),
            ),
          ],
          onDone: () async {
            String? error = await userProvider.signIn();
            if (error != null) return;
            if (!mounted) return;
            pushReplacementScreen(context, const HomeScreen());
          },
          showBackButton: true,
          next: const Icon(Icons.chevron_right),
          back: const Icon(Icons.chevron_left),
          done: const Text(
            '同意する',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            // ここの大きさを変更することで
            // 現在の位置を表しているマーカーのUIが変更するよ!
            activeSize: const Size(20.0, 10.0),
            activeColor: Colors.blue,
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
