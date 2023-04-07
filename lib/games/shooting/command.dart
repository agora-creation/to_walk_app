import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_walk_app/games/shooting/asteroid.dart';
import 'package:to_walk_app/games/shooting/bullet.dart';
import 'package:to_walk_app/games/shooting/controller.dart';
import 'package:to_walk_app/games/shooting/game_bonus.dart';
import 'package:to_walk_app/games/shooting/particle_utils.dart';
import 'package:to_walk_app/games/shooting/scoreboard.dart';
import 'package:to_walk_app/games/shooting/spaceship.dart';

//リストを処理するための単純な削除ゲート
class Broker {
  final _commandList = List<Command>.empty(growable: true);
  final _pendingCommandList = List<Command>.empty(growable: true);
  //一意であるべきメッセージの重複を追跡するための追加リスト
  final _duplicatesWatcher = List<Command>.empty(growable: true);

  Broker();

  //ブローカーにコマンドを追加して処理する
  void addCommand(Command command) {
    if (command.mustBeUnique()) {
      if (_duplicatesWatcher
          .any((element) => element.getId() == command.getId())) {
        //要素がすでにキューにあるため、それをディレガードする
        return;
      } else {
        //ウォッチリストに追加する
        _duplicatesWatcher.add(command);
      }
    }
    //コマンドをキューに追加する
    _pendingCommandList.add(command);
  }

  //スケジュールされたコマンドをすべて処理する
  void process() {
    for (var command in _commandList) {
      command.execute();
    }
    _commandList.clear();
    _commandList.addAll(_pendingCommandList);
    _pendingCommandList.clear();
  }
}

//コマンドパターンを抽象化したもの
abstract class Command {
  Command();

  late Controller _controller;

  Controller _getController() => _controller;

  void addToController(Controller controller) {
    _controller = controller;
    controller.addCommand(this);
  }

  void execute();

  String getTitle();

  //重複したコマンドを識別するためのコマンドID取得
  String getId() => 'Command:0';

  //コマンドが既存のキューでユニークでなければならないかどうかBrokerに知らせる
  bool mustBeUnique() => false;
}

//ユーザーが画面をタップしたことを示す宇宙船クラス
//弾丸を発射するためのコマンドを追加で作成
//弾丸が発射されるとき音を発生させる
class UserTapUpCommand extends Command {
  //コマンドの受信者
  SpaceShip player;

  UserTapUpCommand(this.player);

  @override
  void execute() {
    //プレイヤーの生存チェック
    if (_getController().contains(player)) {
      BulletFiredCommand().addToController(_getController());
      BulletFiredSoundCommand().addToController(_getController());
    }
  }

  @override
  String getTitle() {
    return 'UserTapUpCommand';
  }
}

//新しい弾を作成する
class BulletFiredCommand extends Command {
  BulletFiredCommand();

  @override
  void execute() {
    //真上を向いた速度Vector
    var velocity = Vector2(0, -1);
    //Vectorをplayerと同じ角度に回転させる
    velocity.rotate(_getController().getSpaceShip().angle);
    //特定の角度の弾を作成し、ゲーム上に追加
    BulletBuildContext context = BulletBuildContext()
      ..position =
          _getController().getSpaceShip().getMuzzleComponent.absolutePosition
      ..velocity = velocity
      ..size = Vector2(4, 4);
    Bullet myBullet = BulletFactory.create(
      _getController().getSpaceShip().getBulletType,
      context,
    );
    _getController().add(myBullet);
  }

  @override
  String getTitle() {
    return 'BulletFiredCommand';
  }
}

class BulletDestroyCommand extends Command {
  late Bullet targetBullet;

  BulletDestroyCommand(Bullet bullet) {
    targetBullet = bullet;
  }

  @override
  void execute() {
    targetBullet.onDestroy();
    if (_getController().children.any((element) => targetBullet == element)) {
      _getController().remove(targetBullet);
    }
  }

  @override
  String getTitle() {
    return 'BulletDestroyCommand';
  }
}

class BulletFiredSoundCommand extends Command {
  BulletFiredSoundCommand();

  @override
  void execute() {
    FlameAudio.play('missile_shot.wav', volume: 0.5);
    FlameAudio.play('missile_flyby.wav', volume: 0.2);
  }

  @override
  String getTitle() {
    return 'BulletFiredSoundCommand';
  }
}

class BulletCollisionCommand extends Command {
  late Bullet targetBullet;
  late CollisionCallbacks collisionObject;

  BulletCollisionCommand(Bullet bullet, CollisionCallbacks other) {
    targetBullet = bullet;
    collisionObject = other;
  }

  @override
  void execute() {
    targetBullet.onDestroy();
    _getController().remove(targetBullet);
  }

  @override
  String getTitle() {
    return 'BulletCollisionCommand';
  }

  @override
  String getId() {
    return '${getTitle()}:${targetBullet.hashCode.toString()}';
  }

  @override
  bool mustBeUnique() {
    return true;
  }
}

class AsteroidCollisionCommand extends Command {
  late Asteroid _targetAsteroid;
  late CollisionCallbacks _collisionObject;
  Vector2? _collisionPosition;

  AsteroidCollisionCommand(Asteroid asteroid, CollisionCallbacks other) {
    _targetAsteroid = asteroid;
    _collisionObject = other;
    _collisionPosition = _targetAsteroid.position.clone();
  }

  @override
  void execute() {
    if (_getController().currentLevelObjectStack.contains(_targetAsteroid)) {
      _getController().currentLevelObjectStack.remove(_targetAsteroid);
      bool canBeSplit = _targetAsteroid.canBeSplit();
      if (canBeSplit) {
        ExplosionOfSplitAsteroidRenderCommand(_targetAsteroid)
            .addToController(_getController());
        Vector2 asteroidAVelocity = _targetAsteroid.getVelocity.clone();
        Vector2 asteroidBVelocity = _targetAsteroid.getVelocity.clone();
        asteroidAVelocity.rotate(pi / 4);
        asteroidBVelocity.rotate(-pi / 4);
        AsteroidBuildContext contextA = AsteroidBuildContext()
          ..asteroidType = _targetAsteroid.getSplitAsteroids()[0]
          ..position = _collisionPosition!
          ..velocity = asteroidAVelocity
          ..multiplier = _getController().getResolutionMultiplier;
        AsteroidBuildContext contextB = AsteroidBuildContext()
          ..asteroidType = _targetAsteroid.getSplitAsteroids()[1]
          ..position = _collisionPosition!
          ..velocity = asteroidBVelocity
          ..multiplier = _getController().getResolutionMultiplier;
        Asteroid asteroidA = AsteroidFactory.create(contextA);
        Asteroid asteroidB = AsteroidFactory.create(contextB);
        _getController().currentLevelObjectStack.addAll([asteroidA, asteroidB]);
        _getController().addAll([asteroidA, asteroidB]);
      } else {
        ExplosionOfDestroyedAsteroidRenderCommand(_targetAsteroid)
            .addToController(_getController());
      }
      _targetAsteroid.onDestroy();
      _getController().remove(_targetAsteroid);
    } else {
      return;
    }
  }

  @override
  String getTitle() {
    return 'AsteroidCollisionCommand';
  }
}

class UpdateScoreBoardShotFiredCommand extends Command {
  late ScoreBoard _scoreBoard;

  UpdateScoreBoardShotFiredCommand(scoreBoard) {
    _scoreBoard = scoreBoard;
  }

  @override
  void execute() {
    _scoreBoard.addBulletFired();
  }

  @override
  String getTitle() {
    return 'UpdateScoreBoardShotFiredCommand';
  }
}

class UpdateScoreBoardScoreCommand extends Command {
  late ScoreBoard _scoreBoard;

  UpdateScoreBoardScoreCommand(scoreBoard) {
    _scoreBoard = scoreBoard;
  }

  @override
  void execute() {
    _scoreBoard.addScorePoints(1);
  }

  @override
  String getTitle() {
    return 'UpdateScoreBoardScoreCommand';
  }
}

class UpdateScoreBoardLevelInfoCommand extends Command {
  late ScoreBoard _scoreBoard;

  UpdateScoreBoardLevelInfoCommand(scoreBoard) {
    _scoreBoard = scoreBoard;
  }

  @override
  void execute() {
    _scoreBoard.progressLevel();
    _scoreBoard.resetLevelTimer();
  }

  @override
  String getTitle() {
    return 'UpdateScoreBoardLevelInfoCommand';
  }
}

class UpdateScoreBoardTimePassageInfoCommand extends Command {
  late ScoreBoard _scoreBoard;

  UpdateScoreBoardTimePassageInfoCommand(scoreBoard) {
    _scoreBoard = scoreBoard;
  }

  @override
  void execute() {
    _scoreBoard.addTimeTick();
  }

  @override
  String getTitle() {
    return 'UpdateScoreBoardTimePassageInfoCommand';
  }
}

class PlayerCollisionCommand extends Command {
  late SpaceShip targetPlayer;
  late CollisionCallbacks collisionObject;

  PlayerCollisionCommand(SpaceShip player, CollisionCallbacks other) {
    targetPlayer = player;
    collisionObject = other;
  }

  @override
  void execute() {
    if (_getController().children.contains(targetPlayer)) {
      targetPlayer.onDestroy();
      FlameAudio.play('missile_hit.wav', volume: 0.7);
      _getController().gameRef.camera.shake(duration: 0.5, intensity: 5);
      _getController().remove(targetPlayer);
      ExplosionOfSpaceShipRenderCommand().addToController(_getController());
      PlayerRemoveLifeCommand().addToController(_getController());
    }
  }

  @override
  String getTitle() {
    return 'PlayerCollisionCommand';
  }
}

class PlayerRemoveLifeCommand extends Command {
  PlayerRemoveLifeCommand();

  @override
  void execute() {
    _getController().getScoreBoard.removeLife();
  }

  @override
  String getTitle() {
    return 'PlayerRemoveLifeCommand';
  }
}

class GameOverCommand extends Command {
  GameOverCommand();

  @override
  void execute() async {
    if (_getController().getScoreBoard.getScore >
        _getController().getScoreBoard.getHighScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('highScore', _getController().getScoreBoard.getScore);
    }
  }

  @override
  String getTitle() {
    return 'GameOverCommand';
  }
}

class GameBonusDestroyCommand extends Command {
  late GameBonus targetBonus;

  GameBonusDestroyCommand(GameBonus bonus) {
    targetBonus = bonus;
  }

  @override
  void execute() {
    targetBonus.onDestroy();
    if (_getController()
        .currentLevelObjectStack
        .any((element) => targetBonus == element)) {
      _getController().currentLevelObjectStack.remove(targetBonus);
    }
    if (_getController().children.any((element) => targetBonus == element)) {
      _getController().remove(targetBonus);
    }
  }

  @override
  String getTitle() {
    return 'GameBonusDestroyCommand';
  }
}

class GameBonusCollisionCommand extends Command {
  late GameBonus target;
  late CollisionCallbacks collisionObject;

  GameBonusCollisionCommand(GameBonus gameBonus, CollisionCallbacks other) {
    target = gameBonus;
    collisionObject = other;
  }

  @override
  void execute() {
    ExplosionOfGameBonusRenderCommand(target).addToController(_getController());
    if (collisionObject is Bullet) {}
    _getController().remove(collisionObject);
    if (_getController().currentLevelObjectStack.contains(target)) {
      _getController().currentLevelObjectStack.remove(target);
      target.onDestroy();
      _getController().remove(target);
    } else {
      return;
    }
  }

  @override
  String getTitle() {
    return 'GameBonusCollisionCommand';
  }
}

class ExplosionOfSpaceShipRenderCommand extends Command {
  ExplosionOfSpaceShipRenderCommand();

  @override
  void execute() {
    ExplosionBuildContext context = ExplosionBuildContext()
      ..position = _getController().getSpaceShip().position
      ..images = _getController().getImagesBroker()
      ..explosionType = ExplosionEnum.fieryExplosion;
    ParticleSystemComponent explosion = ExplosionFactory.create(context);
    _getController().add(explosion);
  }

  @override
  String getTitle() {
    return 'ExplosionOfSpaceShipRenderCommand';
  }
}

class ExplosionOfDestroyedAsteroidRenderCommand extends Command {
  late Asteroid _target;

  ExplosionOfDestroyedAsteroidRenderCommand(target) {
    _target = target;
  }

  @override
  void execute() {
    ExplosionBuildContext context = ExplosionBuildContext()
      ..position = _target.position
      ..explosionType = ExplosionEnum.largeParticleExplosion;
    ParticleSystemComponent explosion = ExplosionFactory.create(context);
    _getController().add(explosion);
  }

  @override
  String getTitle() {
    return 'ExplosionOfDestroyedAsteroidRenderCommand';
  }
}

//コマンドで爆発を起こし、ゲームに追加する
class ExplosionOfSplitAsteroidRenderCommand extends Command {
  //操作する小惑星
  late Asteroid _target;

  ExplosionOfSplitAsteroidRenderCommand(target) {
    _target = target;
  }

  @override
  void execute() {
    ExplosionBuildContext context = ExplosionBuildContext()
      ..position = _target.position
      ..explosionType = ExplosionEnum.mediumParticleExplosion;
    ParticleSystemComponent explosion = ExplosionFactory.create(context);
    _getController().add(explosion);
  }

  @override
  String getTitle() {
    return 'ExplosionOfSplitAsteroidRenderCommand';
  }
}

//爆発を作り、ゲームに追加するコマンドの実装
class ExplosionOfGameBonusRenderCommand extends Command {
  //操作するボーナス
  late GameBonus _target;

  ExplosionOfGameBonusRenderCommand(target) {
    _target = target;
  }

  //衝突オブジェクトに基づいて、爆発を作成します
  @override
  void execute() {
    ExplosionBuildContext context = ExplosionBuildContext()
      ..position = _target.position
      ..explosionType = ExplosionEnum.bonusExplosion;
    ParticleSystemComponent explosion = ExplosionFactory.create(context);
    //コントローラーのゲームツリーに追加
    _getController().add(explosion);
  }

  @override
  String getTitle() {
    return 'ExplosionOfGameBonusRenderCommand';
  }
}
