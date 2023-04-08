import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:to_walk_app/games/shooting/command.dart';
import 'package:to_walk_app/games/shooting/controller.dart';

class ShootingGameScreen extends StatefulWidget {
  const ShootingGameScreen({Key? key}) : super(key: key);

  @override
  State<ShootingGameScreen> createState() => _ShootingGameScreenState();
}

class _ShootingGameScreenState extends State<ShootingGameScreen> {
  final game = ShootingGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}

class ShootingGame extends FlameGame
    with HasDraggables, HasTappables, HasCollisionDetection {
  //全てのゲームアクションを調整するために使用されるコントローラー
  late Controller controller;
  //コントローラーに時間の経過を通知するために使用されるタイマー
  late TimerComponent controllerTimer;
  //キャンバスに表示されている船の角度
  TextPaint shipAngleTextPaint = TextPaint();

  @override
  Future onLoad() async {
    await super.onLoad();
    //リソースの初期化
    loadResources();
    //コントローラーを追加する
    controller = Controller();
    add(controller);
    //コントローラーに時間の経過を通知するタイマーを追加します
    controllerTimer = TimerComponent(
      period: 1,
      repeat: true,
      onTick: () => controller.timerNotification(),
    );
    //データのロードを待機
    await controller.init();
    //ゲームオブジェクトツリーにタイマーを追加
    add(controllerTimer);
  }

  //ユーザーがタップして指を話す度に弾丸を発射するために、ユーザーによるタップアクションを処理
  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    UserTapUpCommand(controller.getSpaceship()).addToController(controller);
    super.onTapUp(pointerId, info);
  }

  void loadResources() async {
    //必要なリソースをキャッシュする
    await images.load('boom.png');
  }
}
