import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:to_walk_app/games/shooting/bullet.dart';
import 'package:to_walk_app/games/shooting/controller.dart';
import 'package:to_walk_app/games/shooting/spaceship.dart';

class Broker {
  final _commandList = List<Command>.empty(growable: true);
  final _pendingCommandList = List<Command>.empty(growable: true);
  //一意であるべきメッセージの重複を追跡するための追加リスト
  final _duplicatesWatcher = List<Command>.empty(growable: true);

  Broker();

  void addCommand(Command command) {
    _pendingCommandList.add(command);
  }

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
    velocity.rotate(_getController().getSpaceship().angle);
    //特定の角度の弾を作成し、ゲーム上に追加
    BulletBuildContext context = BulletBuildContext()
      ..position =
          _getController().getSpaceship().muzzleComponent.absolutePosition
      ..velocity = velocity
      ..size = Vector2(4, 4);
    Bullet myBullet = BulletFactory.create(
      _getController().getSpaceship().getBulletType,
      context,
    );
    _getController().add(myBullet);
  }

  @override
  String getTitle() {
    return 'BulletFiredCommand';
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
