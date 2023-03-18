import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/models/steps.dart';

class StepsService {
  final String collection = 'steps';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id() {
    return firestore.collection(collection).doc().id;
  }

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Future<int> getRanking({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) async {
    int ret = 0;
    Timestamp startAt = convertTimestamp(start, false);
    Timestamp endAt = convertTimestamp(end, true);
    await firestore
        .collection(collection)
        .orderBy('createdAt', descending: false)
        .startAt([startAt])
        .endAt([endAt])
        .get()
        .then((value) {
          Map stepsNum = {};
          for (DocumentSnapshot<Map<String, dynamic>> data in value.docs) {
            StepsModel steps = StepsModel.fromSnapshot(data);
            if (stepsNum[steps.userId] == null) {
              stepsNum[steps.userId] = 0;
            }
            stepsNum[steps.userId] += steps.stepsNum;
          }
          var soredKeys = stepsNum.keys.toList(growable: false)
            ..sort((k1, k2) => stepsNum[k2].compareTo(stepsNum[k1]));
          LinkedHashMap sortedMap = LinkedHashMap.fromIterable(soredKeys,
              key: (k) => k, value: (k) => stepsNum[k]);
          int cnt = 1;
          sortedMap.forEach((key, value) {
            if (key == userId) {
              ret = cnt;
            }
            cnt++;
          });
        });
    return ret;
  }
}
