import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

const kTopBottomBorder = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.black54),
    bottom: BorderSide(color: Colors.black54),
  ),
);

const kBottomBorder = BoxDecoration(
  border: Border(
    bottom: BorderSide(color: Colors.black54),
  ),
);

const privacyPolicyUrl = 'https://www.agora-c.com/alk/privacy-policy.html';
const termsUseUrl = 'https://www.agora-c.com/alk/terms_use.html';

//const String androidAdUnitId = 'ca-app-pub-9791675225952080/4790340753'; //本番
const String androidAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; //テスト
//const String iosAdUnitId = 'ca-app-pub-9791675225952080/3780511413'; //本番
const String iosAdUnitId = 'ca-app-pub-3940256099942544/2934735716'; //テスト

const nextExpList = {
  '0': 100,
  '1': 100,
  '2': 100,
  '3': 100,
  '4': 100,
  '5': 100,
  '6': 100,
  '7': 100,
  '8': 100,
  '9': 100,
  '10': 150,
  '11': 150,
  '12': 150,
  '13': 150,
  '14': 150,
  '15': 150,
  '16': 150,
  '17': 150,
  '18': 150,
  '19': 150,
  '20': 200,
  '21': 200,
  '22': 200,
  '23': 200,
  '24': 200,
  '25': 200,
  '26': 200,
  '27': 200,
  '28': 200,
  '29': 200,
  '30': 300,
  '31': 300,
  '32': 300,
  '33': 300,
  '34': 300,
  '35': 300,
  '36': 300,
  '37': 300,
  '38': 300,
  '39': 300,
  '40': 400,
  '41': 400,
  '42': 400,
  '43': 400,
  '44': 400,
  '45': 400,
  '46': 400,
  '47': 400,
  '48': 400,
  '49': 400,
  '50': 500,
};

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
