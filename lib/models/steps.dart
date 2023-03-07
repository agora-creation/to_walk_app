import 'package:cloud_firestore/cloud_firestore.dart';

class StepsModel {
  String _id = '';
  String _userId = '';
  int _stepsNum = 0;
  DateTime _updatedAt = DateTime.now();
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get userId => _userId;
  int get stepsNum => _stepsNum;
  DateTime get updatedAt => _updatedAt;
  DateTime get createdAt => _createdAt;

  StepsModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    _id = snapshot.data()!['id'] ?? '';
    _userId = snapshot.data()!['userId'] ?? '';
    _stepsNum = snapshot.data()!['stepsNum'] ?? 0;
    _updatedAt = snapshot.data()!['updatedAt'].toDate() ?? DateTime.now();
    _createdAt = snapshot.data()!['createdAt'].toDate() ?? DateTime.now();
  }
}
