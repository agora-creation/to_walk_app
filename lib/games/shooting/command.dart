import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:to_walk_app/games/shooting/bullet.dart';
import 'package:to_walk_app/games/shooting/controller.dart';
import 'package:to_walk_app/games/shooting/spaceship.dart';

class Broker {
  final _commandList = List<Command>.empty(growable: true);
  final _pendingCommandList = List<Command>.empty(growable: true);

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
}

class UserTapUpCommand extends Command {
  Spaceship player;

  UserTapUpCommand(this.player);

  @override
  void execute() {
    BulletFiredCommand().addToController(_getController());
    BulletFiredSoundCommand().addToController(_getController());
  }

  @override
  String getTitle() {
    return 'UserTapUpCommand';
  }
}

class BulletFiredCommand extends Command {
  BulletFiredCommand();

  @override
  void execute() {
    var velocity = Vector2(0, -1);
    velocity.rotate(_getController().getSpaceship().angle);
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
