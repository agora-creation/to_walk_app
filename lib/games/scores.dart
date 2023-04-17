import 'package:to_walk_app/helpers/functions.dart';

class Scores {
  static Map<String, dynamic> data = {
    'catchScore': 0,
    'dashScore': 0,
    'jumpScore': 0,
  };

  static Future<void> load() async {
    int catchScore = await getPrefsInt('catchScore') ?? 0;
    int dashScore = await getPrefsInt('dashScore') ?? 0;
    int jumpScore = await getPrefsInt('jumpScore') ?? 0;
    data['catchScore'] = catchScore;
    data['dashScore'] = dashScore;
    data['jumpScore'] = jumpScore;
  }

  static Future<void> catchSave(int score) async {
    if (data['catchScore'] < score) {
      await setPrefsInt('catchScore', score);
      data['catchScore'] = score;
    }
  }

  static Future<void> dashSave(int score) async {
    if (data['dashScore'] < score) {
      await setPrefsInt('dashScore', score);
      data['dashScore'] = score;
    }
  }

  static Future<void> jumpSave(int score) async {
    if (data['jumpScore'] < score) {
      await setPrefsInt('jumpScore', score);
      data['jumpScore'] = score;
    }
  }
}
