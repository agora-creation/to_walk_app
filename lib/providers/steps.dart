import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/models/user.dart';
import 'package:to_walk_app/services/steps.dart';

class StepsProvider with ChangeNotifier {
  StepsService stepsService = StepsService();

  Future<String?> create({
    required UserModel? user,
    required int stepsNum,
  }) async {
    String? errorText;
    if (user == null) return '歩数の登録に失敗しました';
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

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? userId,
  }) {
    Stream<QuerySnapshot<Map<String, dynamic>>>? ret;
    ret = FirebaseFirestore.instance
        .collection('steps')
        .where('userId', isEqualTo: userId ?? 'error')
        .orderBy('createdAt', descending: false)
        .snapshots();
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamListNow({
    required String? userId,
  }) {
    Stream<QuerySnapshot<Map<String, dynamic>>>? ret;
    DateTime now = DateTime.now();
    Timestamp startAt = convertTimestamp(now, false);
    Timestamp endAt = convertTimestamp(now, true);
    ret = FirebaseFirestore.instance
        .collection('steps')
        .where('userId', isEqualTo: userId ?? 'error')
        .orderBy('createdAt', descending: false)
        .startAt([startAt]).endAt([endAt]).snapshots();
    return ret;
  }
}
