import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/helpers/style.dart';
import 'package:to_walk_app/models/steps.dart';
import 'package:to_walk_app/models/user.dart';
import 'package:to_walk_app/models/user_alk.dart';
import 'package:to_walk_app/services/steps.dart';
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
  StepsService stepsService = StepsService();
  UserService userService = UserService();
  UserAlkService userAlkService = UserAlkService();
  UserModel? _user;
  UserModel? get user => _user;
  UserAlkModel? _alk;
  UserAlkModel? get alk => _alk;

  UserProvider.initialize() : auth = FirebaseAuth.instance {
    auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> signIn({
    required String name,
    required int bodyHeight,
    required int bodyWeight,
  }) async {
    String? errorText;
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      await auth?.signInAnonymously().then((value) {
        userService.create({
          'id': value.user?.uid,
          'name': name,
          'birthDate': '',
          'gender': '',
          'country': '',
          'prefecture': '',
          'bodyHeight': bodyHeight,
          'bodyWeight': bodyWeight,
          'createdAt': DateTime.now(),
        });
        userAlkService.create({
          'id': value.user?.uid,
          'userId': value.user?.uid,
          'exp': 0,
          'level': 0,
          'updatedAt': DateTime.now(),
          'createdAt': DateTime.now(),
        });
      });
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      await setPrefsInt('createdAt', timestamp);
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      errorText = 'アプリの起動に失敗しました';
    }
    return errorText;
  }

  Future<String?> signInMigration({required String code}) async {
    String? errorText;
    if (code == '') return 'コードを入力してください';
    UserModel? befUser = await userService.select(id: code);
    if (befUser == null) return 'コードが間違っています';
    UserAlkModel? befAlk = await userAlkService.select(
      id: befUser.id,
      userId: befUser.id,
    );
    if (befAlk == null) return 'コードが間違っています';
    List<StepsModel> befStepsList = await stepsService.selectList(
      userId: befUser.id,
    );
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      await auth?.signInAnonymously().then((value) {
        userService.create({
          'id': value.user?.uid,
          'name': befUser.name,
          'birthDate': befUser.birthDate,
          'gender': befUser.gender,
          'country': befUser.country,
          'prefecture': befUser.prefecture,
          'bodyHeight': befUser.bodyHeight,
          'bodyWeight': befUser.bodyWeight,
          'createdAt': DateTime.now(),
        });
        userAlkService.create({
          'id': value.user?.uid,
          'userId': value.user?.uid,
          'exp': befAlk.exp,
          'level': befAlk.level,
          'updatedAt': DateTime.now(),
          'createdAt': DateTime.now(),
        });
        for (StepsModel steps in befStepsList) {
          stepsService.update({
            'id': steps.id,
            'userId': value.user?.uid,
          });
        }
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

  Future<String?> updateAlkLevelUp() async {
    String? errorText;
    int? nextExp = nextExpList['${alk?.level ?? 0}'];
    if (nextExp == null) return 'レベルアップに失敗しました';
    int? exp = alk?.exp;
    if (exp == null) return 'レベルアップに失敗しました';
    int? level = alk?.level;
    if (level == null) return 'レベルアップに失敗しました';
    if (level == 50) return 'レベルが上限に達しました';
    if (nextExp <= exp) {
      try {
        userAlkService.update({
          'id': alk?.id,
          'userId': alk?.userId,
          'exp': 0,
          'level': level + 1,
          'updatedAt': DateTime.now(),
        });
        notifyListeners();
      } catch (e) {
        errorText = 'レベルアップに失敗しました';
      }
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
