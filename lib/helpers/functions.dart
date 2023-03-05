import 'package:flutter/material.dart';

void pushScreen(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

void pushReplacementScreen(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => widget, fullscreenDialog: true),
  );
}
