import 'package:flutter/material.dart';
import 'style.dart';

ThemeData appTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    textTheme: TextTheme(
      title: titleStyle,
      subtitle: subtitlesStyle,
      caption: paragraphStyle,
      button: loginButtonStyle,
    ),
  );
}
