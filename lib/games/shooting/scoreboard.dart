import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/game.dart';

//ゲームのスコアを表すシンプルなクラス
//ハイスコア、ベストスコアを表示する
class ScoreBoard extends PositionComponent with HasGameRef<ShootingGame> {
  int _highScore = 0;
  int _numOfShotsFired = 0;
  int _score = 0;
  int _livesLeft = 0;
  int _currentLevel = 0;
  int _maxLevels = 0;
  int _timeSinceStartInSeconds = 0;
  int _timeSinceStartOfLevelInSeconds = 0;

  //残りライフ数
  final TextPaint _livesLeftTextPaint = TextPaint(
    style: const TextStyle(
      fontSize: 12,
      fontFamily: 'TsunagiGothic',
      color: Colors.red,
    ),
  );

  //秒速
  final TextPaint _passageOfTimePaint = TextPaint(
    style: const TextStyle(
      fontSize: 12,
      fontFamily: 'TsunagiGothic',
      color: Colors.grey,
    ),
  );

  //スコア
  final TextPaint _scorePaint = TextPaint(
    style: const TextStyle(
      fontSize: 12,
      fontFamily: 'TsunagiGothic',
      color: Colors.green,
    ),
  );

  //ハイスコア
  final TextPaint _highScorePaint = TextPaint(
    style: const TextStyle(
      fontSize: 12,
      fontFamily: 'TsunagiGothic',
      color: Colors.red,
    ),
  );

  //射撃スコア
  final TextPaint _shotsFiredPaint = TextPaint(
    style: const TextStyle(
      fontSize: 12,
      fontFamily: 'TsunagiGothic',
      color: Colors.blue,
    ),
  );

  //レベル
  final TextPaint _levelInfoPaint = TextPaint(
    style: const TextStyle(
      fontSize: 12,
      fontFamily: 'TsunagiGothic',
      color: Colors.amber,
    ),
  );

  ScoreBoard(
    int livesLeft,
    int currentLevel,
    int maxLevels,
  )   : _livesLeft = livesLeft,
        _currentLevel = currentLevel,
        _maxLevels = maxLevels,
        super(priority: 100);

  set highScore(int highScore) {
    if (highScore > 0) {
      _highScore = highScore;
    }
  }

  set lives(int lives) {
    if (lives > 0) {
      _livesLeft = lives;
    }
  }

  set level(int level) {
    if (level > 0) {
      _currentLevel = level;
      _timeSinceStartOfLevelInSeconds = 0;
    }
  }

  int get getLivesLeft => _livesLeft;
  int get getCurrentLevel => _currentLevel;
  int get getTimeSinceStart => _timeSinceStartInSeconds;
  int get getTimeSinceStartOfLevel => _timeSinceStartOfLevelInSeconds;
  int get getScore => _score;
  int get getHighScore => _highScore;

  void addBulletFired() {
    _numOfShotsFired++;
  }

  void addBulletsFired(int numOfBullets) {
    if (numOfBullets > 0) {
      _numOfShotsFired += numOfBullets;
    }
  }

  void addScorePoints(int points) {
    if (points > 0) {
      _score += points;
    }
  }

  void removeLife() {
    if (_livesLeft > 0) {
      _livesLeft--;
    }
    if (_livesLeft <= 0) {}
  }

  void addExtraLife() {
    _livesLeft++;
  }

  void addTimeTick() {
    _timeSinceStartInSeconds++;
    _timeSinceStartOfLevelInSeconds++;
  }

  void resetLevelTimer() {
    _timeSinceStartOfLevelInSeconds = 0;
  }

  void progressLevel() {
    _currentLevel++;
  }

  @override
  void render(Canvas canvas) {
    _livesLeftTextPaint.render(
      canvas,
      formatNumberOfLives(),
      Vector2(20, 16),
    );
    _scorePaint.render(
      canvas,
      'スコア: $_score',
      Vector2(gameRef.size.x - 100, 16),
    );
    _highScorePaint.render(
      canvas,
      'ハイスコア: $_highScore',
      Vector2(gameRef.size.x - 100, 32),
    );
    _shotsFiredPaint.render(
      canvas,
      '射撃: $_numOfShotsFired',
      Vector2(20, 32),
    );
    _levelInfoPaint.render(
      canvas,
      formatLevelData(),
      Vector2(gameRef.size.x - 100, 48),
    );
    _passageOfTimePaint.render(
      canvas,
      'time: $_timeSinceStartInSeconds',
      Vector2(gameRef.size.x - 100, 64),
    );
    super.render(canvas);
  }

  String formatNumberOfLives() {
    if (_livesLeft > 0) {
      return 'ライフ: $_livesLeft';
    } else {
      return "ゲームオーバー";
    }
  }

  String formatLevelData() {
    String result = '';
    if (_currentLevel > 0) {
      result = 'レベル: $_currentLevel';
    } else {
      result = 'レベル: -';
    }
    return '$result of $_maxLevels';
  }
}
