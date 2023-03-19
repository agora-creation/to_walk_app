import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/providers/user.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          scrollPhysics: const BouncingScrollPhysics(),
          pages: [
            PageViewModel(
              title: 'アプリ紹介のページへ\nようこそ!',
              body: '１ページ目だよ！',
              image: Image.asset('assets/images/loading.png'),
            ),
            PageViewModel(
              title: 'アプリの使い方を説明すると\nユーザーにとって親切だよ!',
              body: '2ページ目だよ!',
              image: Image.asset('assets/images/loading.png'),
            ),
            PageViewModel(
              title: '紹介ページを設けることで\n簡単にアプリをリッチにできるよ!',
              body: '3ページ目だよ!',
              image: Image.asset('assets/images/loading.png'),
            ),
          ],
          onDone: () async => Navigator.pop(context),
          showBackButton: true,
          next: const Icon(Icons.arrow_forward_ios),
          back: const Icon(Icons.arrow_back_ios),
          done: const Text(
            'OK!',
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
