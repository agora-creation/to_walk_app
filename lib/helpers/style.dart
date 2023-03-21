import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

ThemeData themeData() {
  return ThemeData(
    scaffoldBackgroundColor: const Color(0xFFB2EBF2),
    fontFamily: 'TsunagiGothic',
    appBarTheme: const AppBarTheme(
      color: Color(0xFF333333),
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: Color(0xFF333333),
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'TsunagiGothic',
      ),
      iconTheme: IconThemeData(color: Color(0xFF333333)),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF333333), fontSize: 18),
      bodyMedium: TextStyle(color: Color(0xFF333333), fontSize: 16),
      bodySmall: TextStyle(color: Color(0xFF333333), fontSize: 14),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

const kTitleStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
);

const kSubTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const kDatePickerTheme = DatePickerTheme(
  cancelStyle: TextStyle(fontFamily: 'TsunagiGothic'),
  doneStyle: TextStyle(fontFamily: 'TsunagiGothic'),
  itemStyle: TextStyle(fontFamily: 'TsunagiGothic'),
);

const healthAPI =
    '1087419833278-vv607sfh4g3am6sp77gvlot7jllju3li.apps.googleusercontent.com';

const genderList = [
  Text('男性'),
  Text('女性'),
  Text('無回答'),
];

const prefectureList = [
  Text('北海道'),
  Text('青森県'),
  Text('岩手県'),
  Text('宮城県'),
  Text('秋田県'),
  Text('山形県'),
  Text('福島県'),
  Text('茨城県'),
  Text('栃木県'),
  Text('群馬県'),
  Text('埼玉県'),
  Text('千葉県'),
  Text('東京都'),
  Text('神奈川県'),
  Text('新潟県'),
  Text('富山県'),
  Text('石川県'),
  Text('福井県'),
  Text('山梨県'),
  Text('長野県'),
  Text('岐阜県'),
  Text('静岡県'),
  Text('愛知県'),
  Text('三重県'),
  Text('滋賀県'),
  Text('京都府'),
  Text('大阪府'),
  Text('兵庫県'),
  Text('奈良県'),
  Text('和歌山県'),
  Text('鳥取県'),
  Text('島根県'),
  Text('岡山県'),
  Text('広島県'),
  Text('山口県'),
  Text('徳島県'),
  Text('香川県'),
  Text('愛媛県'),
  Text('高知県'),
  Text('福岡県'),
  Text('佐賀県'),
  Text('長崎県'),
  Text('熊本県'),
  Text('大分県'),
  Text('宮崎県'),
  Text('鹿児島県'),
  Text('沖縄県'),
];
