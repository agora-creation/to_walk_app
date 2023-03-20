import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserAlkModel {
  String _id = '';
  String _userId = '';
  int _level = 0;
  double _speed = 0.0;
  double _jump = 0.0;
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
    _speed = double.parse('${snapshot.data()!['speed']}');
    _jump = double.parse('${snapshot.data()!['jump']}');
    _updatedAt = snapshot.data()!['updatedAt'].toDate() ?? DateTime.now();
    _createdAt = snapshot.data()!['createdAt'].toDate() ?? DateTime.now();
  }

  String getRoomName() {
    if (level >= 10) {
      return 'アルクの部屋';
    } else {
      return '？？？';
    }
  }

  Widget getImage() {
    String imagePath = '';
    switch (_level) {
      case 0:
        imagePath = 'assets/images/alk_0.png';
        break;
      case 1:
        imagePath = 'assets/images/alk_0.png';
        break;
      case 2:
        imagePath = 'assets/images/alk_0.png';
        break;
      case 3:
        imagePath = 'assets/images/alk_0.png';
        break;
      case 4:
        imagePath = 'assets/images/alk_0.png';
        break;
      case 5:
        imagePath = 'assets/images/alk_0.png';
        break;
    }
    return Center(
      child: Image.asset(
        imagePath,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
