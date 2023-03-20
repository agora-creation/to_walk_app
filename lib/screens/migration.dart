import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/models/user.dart';
import 'package:to_walk_app/providers/user.dart';

class MigrationScreen extends StatefulWidget {
  const MigrationScreen({Key? key}) : super(key: key);

  @override
  State<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends State<MigrationScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    UserModel? user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2EBF2),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text('引き継ぎ'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'スマートフォンの機種変や本体の交換などを行った際、今までのアプリのデータを引き継ぐための機能です。',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                  const Text(
                    '新しいスマートフォンで本アプリを始めた際、引き継ぎ用のコードを聞かれますので、以下のコードを入力してください。',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    user?.id ?? '',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    '引き継ぎが完了次第、本アプリをアンインストールしてください。',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                  const Text(
                    '引き続き本アプリをお楽しみください！',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
