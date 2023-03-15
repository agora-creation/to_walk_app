import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/models/user.dart';
import 'package:to_walk_app/models/user_alk.dart';
import 'package:to_walk_app/services/user.dart';
import 'package:to_walk_app/services/user_alk.dart';

enum AuthStatus {
  authenticated,
  uninitialized,
  authenticating,
  unauthenticated,
}

class UserProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;
  AuthStatus get status => _status;
  FirebaseAuth? auth;
  User? _fUser;
  UserService userService = UserService();
  UserAlkService userAlkService = UserAlkService();
  UserModel? _user;
  UserModel? get user => _user;
  UserAlkModel? _alk;
  UserAlkModel? get alk => _alk;

  UserProvider.initialize() : auth = FirebaseAuth.instance {
    auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> signIn() async {
    String? errorText;
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      await auth?.signInAnonymously().then((value) {
        userService.create({
          'id': value.user?.uid,
          'name': '',
          'birthDate': '',
          'gender': '',
          'country': '',
          'prefecture': '',
          'bodyHeight': 0,
          'bodyWeight': 0,
          'createdAt': DateTime.now(),
        });
        userAlkService.create({
          'id': value.user?.uid,
          'userId': value.user?.uid,
          'level': 0,
          'speed': 0,
          'jump': 0,
          'updatedAt': DateTime.now(),
          'createdAt': DateTime.now(),
        });
      });
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      errorText = 'アプリの起動に失敗しました';
    }
    return errorText;
  }

  Future<String?> updateName(String name) async {
    String? errorText;
    try {
      userService.update({
        'id': user?.id,
        'name': name,
      });
    } catch (e) {
      errorText = '名前の登録に失敗しました';
    }
    return errorText;
  }

  Future<String?> updateBirthDate(String birthDate) async {
    String? errorText;
    try {
      userService.update({
        'id': user?.id,
        'birthDate': birthDate,
      });
    } catch (e) {
      errorText = '生年月日の登録に失敗しました';
    }
    return errorText;
  }

  Future<String?> updateGender(String gender) async {
    String? errorText;
    try {
      userService.update({
        'id': user?.id,
        'gender': gender,
      });
    } catch (e) {
      errorText = '性別の登録に失敗しました';
    }
    return errorText;
  }

  Future<String?> updatePrefecture(String prefecture) async {
    String? errorText;
    try {
      userService.update({
        'id': user?.id,
        'prefecture': prefecture,
      });
    } catch (e) {
      errorText = '居住都道府県の登録に失敗しました';
    }
    return errorText;
  }

  Future<String?> updateBodyHeight(int bodyHeight) async {
    String? errorText;
    try {
      userService.update({
        'id': user?.id,
        'bodyHeight': bodyHeight,
      });
    } catch (e) {
      errorText = '身長の登録に失敗しました';
    }
    return errorText;
  }

  Future<String?> updateBodyWeight(int bodyWeight) async {
    String? errorText;
    try {
      userService.update({
        'id': user?.id,
        'bodyWeight': bodyWeight,
      });
    } catch (e) {
      errorText = '体重の登録に失敗しました';
    }
    return errorText;
  }

  Future signOut() async {
    await auth?.signOut();
    _status = AuthStatus.unauthenticated;
    _user = null;
    _alk = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future reload() async {
    String uid = _fUser?.uid ?? '';
    if (uid != '') {
      _user = await userService.select(id: uid);
      _alk = await userAlkService.select(id: uid, userId: uid);
    }
    notifyListeners();
  }

  Future _onStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _fUser = firebaseUser;
      _status = AuthStatus.authenticated;
      String uid = _fUser?.uid ?? '';
      if (uid != '') {
        _user = await userService.select(id: uid);
        _alk = await userAlkService.select(id: uid, userId: uid);
      }
    }
    notifyListeners();
  }
}
