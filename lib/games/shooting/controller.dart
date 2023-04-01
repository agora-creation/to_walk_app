import 'package:flame/components.dart';
import 'package:to_walk_app/games/shooting/command.dart';
import 'package:to_walk_app/games/shooting/game.dart';
import 'package:to_walk_app/games/shooting/spaceship.dart';

class Controller extends Component with HasGameRef<ShootingGame> {
  final Broker _broker = Broker();

  Spaceship getSpaceship() => gameRef.player;

  @override
  void update(double dt) {
    _broker.process();
    super.update(dt);
  }

  void addCommand(Command command) {
    _broker.addCommand(command);
  }
}
