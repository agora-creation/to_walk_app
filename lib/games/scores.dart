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
    await setPrefsInt('catchScore', score);
    data['catchScore'] = score;
  }

  static Future<void> dashSave(int score) async {
    await setPrefsInt('dashScore', score);
    data['dashScore'] = score;
  }

  static Future<void> jumpSave(int score) async {
    await setPrefsInt('jumpScore', score);
    data['jumpScore'] = score;
  }
}
