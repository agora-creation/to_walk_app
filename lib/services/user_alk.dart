import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_walk_app/models/user_alk.dart';

class UserAlkService {
  final String collection = 'user';
  final String subCollection = 'alk';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id({required String userId}) {
    return firestore
        .collection(collection)
        .doc(userId)
        .collection(subCollection)
        .doc()
        .id;
  }

  void create(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['userId'])
        .collection(subCollection)
        .doc(values['id'])
        .set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['userId'])
        .collection(subCollection)
        .doc(values['id'])
        .update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['userId'])
        .collection(subCollection)
        .doc(values['id'])
        .delete();
  }

  Future<UserAlkModel?> select({
    required String id,
    required String userId,
  }) async {
    UserAlkModel? alk;
    await firestore
        .collection(collection)
        .doc(userId)
        .collection(subCollection)
        .doc(id)
        .get()
        .then((value) {
      alk = UserAlkModel.fromSnapshot(value);
    });
    return alk;
  }
}
