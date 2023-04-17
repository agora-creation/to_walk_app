import 'package:to_walk_app/helpers/functions.dart';

class Scores {
  static Map<String, dynamic> data = {
    'catchScore': 0,
    'jumpScore': 0,
  };

  static Future<void> load() async {
    int catchScore = await getPrefsInt('catchScore') ?? 0;
    int jumpScore = await getPrefsInt('jumpScore') ?? 0;
    data['catchScore'] = catchScore;
    data['jumpScore'] = jumpScore;
  }

  static Future<void> catchSave(int score) async {
    if (data['catchScore'] < score) {
      await setPrefsInt('catchScore', score);
      data['catchScore'] = score;
    }
  }

  static Future<void> jumpSave(int score) async {
    if (data['jumpScore'] < score) {
      await setPrefsInt('jumpScore', score);
      data['jumpScore'] = score;
    }
  }
}
