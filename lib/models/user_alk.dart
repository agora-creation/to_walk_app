import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserAlkModel {
  String _id = '';
  String _userId = '';
  int _exp = 0;
  int _level = 0;
  DateTime _updatedAt = DateTime.now();
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get userId => _userId;
  int get exp => _exp;
  int get level => _level;
  DateTime get updatedAt => _updatedAt;
  DateTime get createdAt => _createdAt;

  UserAlkModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    _id = snapshot.data()!['id'] ?? '';
    _userId = snapshot.data()!['userId'] ?? '';
    _exp = snapshot.data()!['exp'] ?? 0;
    _level = snapshot.data()!['level'] ?? 0;
    _updatedAt = snapshot.data()!['updatedAt'].toDate() ?? DateTime.now();
    _createdAt = snapshot.data()!['createdAt'].toDate() ?? DateTime.now();
  }

  String getRoomName() {
    if (level >= 1) {
      return 'アルク';
    } else {
      return '？？？';
    }
  }

  String getRoomMessage() {
    String ret = 'タマゴ';
    if (level >= 1) {
      ret = 'アルク (Lv.$level)';
    }
    return ret;
  }

  String getRoomMessage2() {
    String ret = '歩くと生まれるかも...？';
    if (level >= 1) {
      ret = '歩くとLvが上がるかも...？';
    }
    return ret;
  }

  Widget getImage() {
    String imagePath = '';
    if (_level == 0) {
      imagePath = 'assets/images/alk_0.png';
    } else if (1 <= _level && _level <= 10) {
      imagePath = 'assets/images/alk_0.png';
    } else if (11 <= _level && _level <= 20) {
      imagePath = 'assets/images/alk_0.png';
    } else if (21 <= _level && _level <= 30) {
      imagePath = 'assets/images/alk_0.png';
    } else if (31 <= _level && _level <= 40) {
      imagePath = 'assets/images/alk_0.png';
    } else if (41 <= _level) {
      imagePath = 'assets/images/alk_0.png';
    }
    return Center(
      child: Image.asset(
        imagePath,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
