import 'package:flutter/material.dart';
import 'package:to_walk_app/models/user.dart';
import 'package:to_walk_app/services/steps.dart';

class StepsProvider with ChangeNotifier {
  StepsService stepsService = StepsService();

  Future<String?> create({
    required UserModel user,
    required int stepsNum,
  }) async {
    String? errorText;
    try {
      String id = stepsService.id();
      stepsService.create({
        'id': id,
        'userId': user.id,
        'stepsNum': stepsNum,
        'updatedAt': DateTime.now(),
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      errorText = '歩数の登録に失敗しました';
    }
    return errorText;
  }
}
