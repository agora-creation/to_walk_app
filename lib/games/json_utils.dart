import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:to_walk_app/games/catch/objects/bomb.dart';
import 'package:to_walk_app/games/catch/objects/carrot.dart';
import 'package:to_walk_app/games/jump/objects/cloud.dart';

class JsonUtils {
  static dynamic readCatch() async {
    String res = await rootBundle.loadString('assets/json/catch_game.json');
    final data = await json.decode(res);
    return data;
  }

  static dynamic readJump() async {
    String res = await rootBundle.loadString('assets/json/jump_game.json');
    final data = await json.decode(res);
    return data;
  }

  static List<BombObject> extractBomb(dynamic data) {
    List<BombObject> result = [];
    for (final e in data['bomb']) {
      BombObject bomb = BombObject(
        x: e['x'].toDouble(),
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
        gravity: e['gravity'].toDouble(),
        time: e['time'].toInt(),
      );
      result.add(carrot);
    }
    return result;
  }

  static List<CloudObject> extractCloud(dynamic data) {
    List<CloudObject> result = [];
    for (final e in data['cloud']) {
      CloudObject cloud = CloudObject(
        y: e['y'].toDouble(),
        time: e['time'].toInt(),
      );
      result.add(cloud);
    }
    return result;
  }
}
