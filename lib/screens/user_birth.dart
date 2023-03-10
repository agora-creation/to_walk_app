import 'package:flutter/material.dart';

class UserBirthScreen extends StatefulWidget {
  const UserBirthScreen({Key? key}) : super(key: key);

  @override
  State<UserBirthScreen> createState() => _UserBirthScreenState();
}

class _UserBirthScreenState extends State<UserBirthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text('あなたの生年月日'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('登録する'),
          ),
        ],
      ),
    );
  }
}
