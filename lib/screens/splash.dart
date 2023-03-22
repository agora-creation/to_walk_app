import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_walk_app/helpers/style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SizedBox(
            height: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: const [
                        Text('アルク', style: kTitleStyle),
                        SizedBox(height: 8),
                        Text('- ウォーキング連動育成ゲーム -', style: kSubTitleStyle),
                      ],
                    ),
                    SizedBox(
                      width: 80,
                      child: Center(
                        child: Image.asset(
                          'assets/images/loading.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
