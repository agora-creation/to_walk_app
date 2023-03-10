import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/models/steps.dart';
import 'package:to_walk_app/services/steps.dart';

class StepsProvider with ChangeNotifier {
  StepsService stepsService = StepsService();

  Future<String?> create({required List<StepsModel> stepsList}) async {
    String? errorText;
    try {
      for (StepsModel steps in stepsList) {
        stepsService.create({
          'id': steps.id,
          'userId': steps.userId,
          'stepsNum': steps.stepsNum,
          'updatedAt': steps.updatedAt,
          'createdAt': steps.createdAt,
        });
      }
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
