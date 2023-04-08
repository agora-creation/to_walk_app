import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_walk_app/games/shooting/asteroid.dart';
import 'package:to_walk_app/games/shooting/command.dart';
import 'package:to_walk_app/games/shooting/game.dart';
import 'package:to_walk_app/games/shooting/game_bonus.dart';
import 'package:to_walk_app/games/shooting/json_utils.dart';
import 'package:to_walk_app/games/shooting/scoreboard.dart';
import 'package:to_walk_app/games/shooting/spaceship.dart';

//コントローラーは、ゲーム運営の中心的な存在
//実行されるコマンドの派遣だけでなく、状態の整理
//状態はゲームに参加するすべてのゲーム要素で構成される
//メッセージングを行う
//コントローラーは、コマンドの管理をBrokerに委ねる
//保留中のコマンドの実行をスケジュール
class Controller extends Component with HasGameRef<ShootingGame> {
  //プレイヤーのライフの数：スタート時
  static const defaultNumberOfLives = 4;
  static const defaultStartLevel = 0;
  //秒速でレベルや新生活の間にポーズ
  static const timeoutPauseInSeconds = 3;
  int _pauseCountdown = 0;
  bool _levelDoneFlag = false;
  int _respawnCountdown = 0;
  bool _playerDiedFlag = false;
  //すべてのコマンドを実行する専用ヘルパー
  final Broker _broker = Broker();

  late final JoystickComponent _joystick;
  //JSONから読み込んだすべてのゲームレベル
  late List<GameLevel> _gameLevels;
  int _currentGameLevelIndex = 0;
  //現在のレベルからすべてのオブジェクトを保持するために使用されるスタック
  //このスタックが空なら次のレベルへ行く
  List currentLevelObjectStack = List.empty(growable: true);
  //JSONデータの初期化
  late dynamic jsonData;
  //レベルがテザリングされるデフォルトの解像度を計算するために使用
  //異なるオブジェクトの位置、大きさ、速度が同じになるように
  late Vector2 _baseResolution;
  final Vector2 _resolutionMultiplier = Vector2.all(1);
  late final ScoreBoard _scoreBoard;
  late SpaceShip player;
  late Images images;

  SpaceShip getSpaceShip() => player;
  Images getImagesBroker() => gameRef.images;

  Future init() async {
    jsonData = await JSONUtils.readJsonInitData();
    //解像度を読み込んで、解像度倍率を計算します
    _baseResolution = JSONUtils.extractBaseGameResolution(jsonData);
    _resolutionMultiplier.x = gameRef.size.x / _baseResolution.x;
    _resolutionMultiplier.y = gameRef.size.y / _baseResolution.y;
    //ゲームのレベルなどゲームに関連するJSONデータを読み込む
    _gameLevels = JSONUtils.extractGameLevels(jsonData);
    //スコアボードの初期化
    _scoreBoard = ScoreBoard(
      defaultNumberOfLives,
      defaultStartLevel,
      _gameLevels.length,
    );
    //ハイスコアがあればそれを読み込んで、スコアボードデータを作成する
    final prefs = await SharedPreferences.getInstance();
    //ハイスコアキーからデータを読み込む
    int? userHighScore = prefs.getInt('highScore');
    if (userHighScore != null) _scoreBoard.highScore = userHighScore;
    //サブコンポーネントの初期化
    add(_scoreBoard);
    //ジョイスティックノブおよび背景のスキンスタイル
    final knobPaint = BasicPalette.green.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.green.withAlpha(100).paint();
    //ジョイスティックコンポーネントを作成
    _joystick = JoystickComponent(
      knob: CircleComponent(radius: 15, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );
    //コントローラーのコンポーネントツリーに、プレイヤーとジョイスティックを追加
    spawnNewPlayer();
    add(_joystick);
  }

  //タイマーフック
  //ゲームの正確な時間経過を秒単位で監視する
  void timerNotification() {
    //スコアボードの時間経過を更新する
    UpdateScoreBoardTimePassageInfoCommand(_scoreBoard).addToController(this);

    //ボーナスをチェック
    if (_scoreBoard.getCurrentLevel > 0) {
      int currentTimeTick = _scoreBoard.getTimeSinceStartOfLevel;
      if (_gameLevels[_scoreBoard.getCurrentLevel - 1]
          .shouldSpawnBonus(currentTimeTick)) {
        GameBonusBuildContext? context =
            _gameLevels[_scoreBoard.getCurrentLevel - 1]
                .getBonus(currentTimeTick);
        if (context != null) {
          //ボーナスを組み、ゲームに追加する
          GameBonus? bonus = GameBonusFactory.create(context);
          currentLevelObjectStack.add(bonus);
          add(bonus!);
        }
      }
    }

    //新レベル生成のためのテスト
    if (isCurrentLevelFinished()) {
      loadNextGameLevel();
    }

    //プレイヤー生成のためのテスト
    if (shouldRespawnPlayer()) {
      spawnNewPlayer();
    }
  }

  //コントローラーがブローカーに指示します
  //未処理のコマンドをすべて処理する
  @override
  void update(double dt) {
    _broker.process();
    super.update(dt);
  }

  //ブローカーにデリゲートして処理するコマンドを予約する
  void addCommand(Command command) {
    _broker.addCommand(command);
  }

  List<GameLevel> get getLevels => _gameLevels;
  Vector2 get getBaseResolution => _baseResolution;
  Vector2 get getResolutionMultiplier => _resolutionMultiplier;
  ScoreBoard get getScoreBoard => _scoreBoard;

  //次のゲームレベルをロードして画面に表示する
  void loadNextGameLevel() {
    List<Asteroid> asteroids = List.empty(growable: true);
    List<GameBonus> gameBonuses = List.empty(growable: true);
    //念の為オブジェクトスタックを空にする
    currentLevelObjectStack.clear();
    //余地を残す
    if (_currentGameLevelIndex < _gameLevels.length) {
      for (var asteroid in _gameLevels[_currentGameLevelIndex].asteroidConfig) {
        asteroid.multiplier = _resolutionMultiplier;
        //小惑星を作る
        Asteroid newAsteroid = AsteroidFactory.create(asteroid);
        asteroids.add(newAsteroid);
        currentLevelObjectStack.add(asteroids.last);
      }
      //すべての小惑星をコンポーネントツリーに追加します
      addAll(asteroids);
      //レベルカウンタを更新する
      _currentGameLevelIndex++;
    }
  }

  void spawnNewPlayer() {
    //ジョイスティックで操作するプレイヤーの作成
    PlayerBuildContext context = PlayerBuildContext()
      ..spaceShipType = SpaceShipEnum.simpleSpaceShip
      ..joystick = _joystick
      ..multiplier = getResolutionMultiplier;
    player = SpaceShipFactory.create(context);
    add(player);
  }

  //現在のレベルが終了しているかどうかをチェックする
  //また、レベル生成を一時停止するために、数秒のバリアを追加します
  //プレイヤーに数秒の猶予を与える
  bool isCurrentLevelFinished() {
    if (currentLevelObjectStack.isEmpty) {
      if (_levelDoneFlag == false) {
        _levelDoneFlag = true;
        _pauseCountdown = timeoutPauseInSeconds;
        return false;
      }
      if (_levelDoneFlag == true) {
        if (_pauseCountdown == 0) {
          _levelDoneFlag = false;
          return true;
        } else {
          _pauseCountdown--;
          return false;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  //現在のレベルが終了しているかどうかをチェックする
  //また、レベル生成を一時停止するために、数秒のバリアを追加します
  //プレイヤーに数秒の猶予を与える
  bool shouldRespawnPlayer() {
    if (!children.any((element) => element is SpaceShip)) {
      if (_playerDiedFlag == false) {
        _playerDiedFlag = true;
        _respawnCountdown = timeoutPauseInSeconds;
        return false;
      }
      if (_playerDiedFlag == true && _scoreBoard.getLivesLeft > 0) {
        if (_respawnCountdown == 0) {
          _playerDiedFlag = false;
          return true;
        } else {
          _respawnCountdown--;
          return false;
        }
      }
      return false;
    } else {
      return false;
    }
  }
}

//小惑星の位置と速度を保持できる1つのゲームレベルである
//UFOボーナスのデータも、タイムスタンプで特定される
//レベルでどのようにアップすべきかの瞬間
class GameLevel {
  List<AsteroidBuildContext> asteroidConfig = [];
  List<GameBonusBuildContext> gameBonusConfig = [];
  final Map<int, GameBonusBuildContext> _gameBonusMap = {};

  GameLevel();

  void init() {
    for (GameBonusBuildContext bonus in gameBonusConfig) {
      _gameBonusMap[bonus.timeTriggerSeconds] = bonus;
    }
  }

  bool shouldSpawnBonus(int timeTick) {
    if (_gameBonusMap[timeTick] != null) {
      return true;
    } else {
      return false;
    }
  }

  GameBonusBuildContext? getBonus(int timeTick) {
    return _gameBonusMap[timeTick];
  }
}
