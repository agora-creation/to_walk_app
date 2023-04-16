import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class JsonUtils {
  static dynamic read() async {
    Map<String, dynamic> resolution = {};
    String res = await rootBundle.loadString('assets/json/catch_game.json');
    final data = await json.decode(res);
    return data;
  }

  static Vector2 extractResolution(dynamic data) {
    Vector2 result = Vector2.zero();
    Map<String, dynamic> resolution = {};
    resolution = data['game_data']['resolution'];
    result = Vector2(
      resolution['x'].toDouble(),
      resolution['y'].toDouble(),
    );
    return result;
  }
}
