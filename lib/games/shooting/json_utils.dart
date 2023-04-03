//主にコントローラーがゲームを初期化するために使用されます
//要素、レベル、解像度倍率などのゲームデータ

import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class JSONUtils {
  //JSONデータを読み込む
  static dynamic readJsonInitData() async {
    List _levels = [];
    Map<String, dynamic> _jsonDataResolution = {};
    List _jsonDataLevels = [];
    final String response = await rootBundle.loadString(
      'assets/game_config.json',
    );
    final data = await json.decode(response);
    _jsonDataResolution = data['game_data']['resolution'];
    _jsonDataLevels = data['game_data']['levels'];
    return data;
  }

  //JSONデータからゲームレベルを取得する

  //JSONデータから解像度を取得する
  static Vector2 extractBaseGameResolution(dynamic data) {
    Vector2 result = Vector2.zero();
    Map _jsonDataResolution = {};
    _jsonDataResolution = data['game_data']['resolution'];
    result = Vector2(
      _jsonDataResolution['x'].toDouble(),
      _jsonDataResolution['y'].toDouble(),
    );
    return result;
  }

  //JSONレベルのデータを、隕石に割り当てる
  //JSONレベルのデータを、ゲームボーナスに割り当てる
}
