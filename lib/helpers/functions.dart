import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void pushScreen(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

void pushReplacementScreen(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => widget, fullscreenDialog: true),
  );
}

Future<int?> getPrefsInt(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}

Future setPrefsInt(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

Future<String?> getPrefsString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future setPrefsString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<bool?> getPrefsBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

Future setPrefsBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

Future removePrefs(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

String dateText(String format, DateTime? date) {
  String ret = '';
  if (date != null) {
    ret = DateFormat(format, 'ja').format(date);
  }
  return ret;
}

String randomString(int length) {
  const randomChars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  const charsLength = randomChars.length;
  final rand = Random();
  final codeUnits = List.generate(
    length,
    (index) {
      final n = rand.nextInt(charsLength);
      return randomChars.codeUnitAt(n);
    },
  );
  return String.fromCharCodes(codeUnits);
}

Timestamp convertTimestamp(DateTime date, bool end) {
  String dateTime = '${dateText('yyyy-MM-dd', date)} 00:00:00.000';
  if (end == true) {
    dateTime = '${dateText('yyyy-MM-dd', date)} 23:59:59.999';
  }
  return Timestamp.fromMillisecondsSinceEpoch(
    DateTime.parse(dateTime).millisecondsSinceEpoch,
  );
}

String calculationBMI(double height, double weight) {
  String ret = '測定不能';
  double m = height * 0.01;
  double bmi = weight / (m * m);
  if (bmi < 16) {
    ret = 'やせすぎ';
  } else if (bmi < 17) {
    ret = 'やせている';
  } else if (bmi < 18.5) {
    ret = 'やせぎみ';
  } else if (bmi < 25) {
    ret = '標準';
  } else if (bmi < 30) {
    ret = 'ぽっちゃり気味';
  } else if (bmi < 35) {
    ret = 'ぽっちゃり';
  } else if (bmi < 40) {
    ret = 'ふとっている';
  } else if (bmi > 40) {
    ret = 'ふとりすぎ';
  }
  return ret;
}
