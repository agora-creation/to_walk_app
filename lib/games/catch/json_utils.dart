import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:to_walk_app/games/catch/objects/bomb.dart';
import 'package:to_walk_app/games/catch/objects/carrot.dart';

class JsonUtils {
  static dynamic read() async {
    String res = await rootBundle.loadString('assets/json/catch_game.json');
    final data = await json.decode(res);
    return data;
  }

  static List<BombObject> extractBomb(dynamic data) {
    List<BombObject> result = [];
    for (final e in data['bomb']) {
      BombObject bomb = BombObject(
        x: e['x'].toDouble(),
        y: e['y'].toDouble(),
        gravity: e['gravity'].toDouble(),
        time: e['time'].toInt(),
      );
      result.add(bomb);
    }
    return result;
  }

  static List<CarrotObject> extractCarrot(dynamic data) {
    List<CarrotObject> result = [];
    for (final e in data['carrot']) {
      CarrotObject carrot = CarrotObject(
        x: e['x'].toDouble(),
        y: e['y'].toDouble(),
        gravity: e['gravity'].toDouble(),
        time: e['time'].toInt(),
      );
      result.add(carrot);
    }
    return result;
  }
}
