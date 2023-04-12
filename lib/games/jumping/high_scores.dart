import 'package:to_walk_app/helpers/functions.dart';

class HighScores {
  static final highScores = List.filled(5, 0);

  static Future<void> load() async {
    for (int i = 0; i < 5; i++) {
      int score = await getPrefsInt('score$i') ?? 0;
      highScores[i] = score;
    }
  }

  static Future<void> save(int score) async {
    for (int i = 0; i < 5; i++) {
      if (highScores[i] < score) {
        for (int j = 4; j > i; j--) {
          highScores[j] = highScores[j - 1];
        }
        highScores[i] = score;
        break;
      }
    }
    for (int i = 0; i < 5; i++) {
      await setPrefsInt('score$i', highScores[i]);
    }
  }
}
