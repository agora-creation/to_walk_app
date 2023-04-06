import 'package:flame/cache.dart';
import 'package:flame/components.dart';
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
  }

  @override
  void update(double dt) {
    _broker.process();
    super.update(dt);
  }

  void addCommand(Command command) {
    _broker.addCommand(command);
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
