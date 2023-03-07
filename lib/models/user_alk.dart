import 'package:cloud_firestore/cloud_firestore.dart';

class UserAlkModel {
  String _id = '';
  String _userId = '';
  int _level = 0;
  double _speed = 0;
  double _jump = 0;
  DateTime _updatedAt = DateTime.now();
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get userId => _userId;
  int get level => _level;
  double get speed => _speed;
  double get jump => _jump;
  DateTime get updatedAt => _updatedAt;
  DateTime get createdAt => _createdAt;

  UserAlkModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    _id = snapshot.data()!['id'] ?? '';
    _userId = snapshot.data()!['userId'] ?? '';
    _level = snapshot.data()!['level'] ?? 0;
    _speed = snapshot.data()!['speed'] ?? 0;
    _jump = snapshot.data()!['jump'] ?? 0;
    _updatedAt = snapshot.data()!['updatedAt'].toDate() ?? DateTime.now();
    _createdAt = snapshot.data()!['createdAt'].toDate() ?? DateTime.now();
  }
}
