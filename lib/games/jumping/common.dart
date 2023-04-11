import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
bool get isMobile => isIOS && isAndroid;

final screenSize = Vector2(428, 926);
final worldSize = Vector2(4.28, 9.26);

enum GameState { running, gameOver }
