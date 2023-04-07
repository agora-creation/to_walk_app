import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:to_walk_app/games/shooting/asteroid.dart';
import 'package:to_walk_app/games/shooting/controller.dart';
import 'package:to_walk_app/games/shooting/game_bonus.dart';

//JSONユーティリティ
//主にコントローラーがゲームを初期化するために使用されます
//要素、レベル、解像度倍率などのゲームデータ
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
  static List<GameLevel> extractGameLevels(dynamic data) {
    List<GameLevel> result = List.empty(growable: true);
    List _jsonDataLevels = [];
    _jsonDataLevels = data['game_data']['level'];
    for (var level in _jsonDataLevels) {
      GameLevel gameLevel = GameLevel();
      List<AsteroidBuildContext> asteroidContextList =
          _buildAsteroidData(level);
      List<GameBonusBuildContext> gameBonusContextList =
          _buildGameBonusData(level);
      gameLevel
        ..asteroidConfig = asteroidContextList
        ..gameBonusConfig = gameBonusContextList;
      gameLevel.init();
      result.add(gameLevel);
    }
    return result;
  }

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

  //JSONレベルのデータを、小惑星に割り当てる
  static List<AsteroidBuildContext> _buildAsteroidData(Map data) {
    List<AsteroidBuildContext> result = List.empty(growable: true);
    for (final e in data['asteroids']) {
      AsteroidBuildContext asteroid = AsteroidBuildContext();
      asteroid.asteroidType = AsteroidBuildContext.asteroidFromString(
        e['name'],
      );
      asteroid.position = Vector2(
        e['position.x'].toDouble(),
        e['position.y'].toDouble(),
      );
      asteroid.velocity = Vector2(
        e['velocity.x'].toDouble(),
        e['velocity.y'].toDouble(),
      );
      result.add(asteroid);
    }
    return result;
  }

  //JSONレベルのデータを、ゲームボーナスに割り当てる
  static List<GameBonusBuildContext> _buildGameBonusData(Map data) {
    List<GameBonusBuildContext> result = List.empty(growable: true);
    if (data['gameBonus'] == null) return result;
    for (final e in data['gameBonus']) {
      GameBonusBuildContext gameBonus = GameBonusBuildContext();
      gameBonus.gameBonusType = GameBonusBuildContext.gameBonusFromString(
        e['name'],
      );
      gameBonus.position = Vector2(
        e['position.x'].toDouble(),
        e['position.y'].toDouble(),
      );
      gameBonus.velocity = Vector2(
        e['velocity.x'].toDouble(),
        e['velocity.y'].toDouble(),
      );
      gameBonus.timeTriggerSeconds = e['trigger.time.seconds'].toInt();
      result.add(gameBonus);
    }

    return result;
  }
}
