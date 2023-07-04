import 'package:flutter/material.dart';
import 'hexColor.dart';

/*
テーマを決めるためのウィジェット
*/
class theme {
  const theme._internal();

  static final ThemeData data = ThemeData(
    scaffoldBackgroundColor: HexColor('ffffff'),
    fontFamily: 'Mintyou',
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: HexColor('262626'),
        primary: Colors.white,
        textStyle: TextStyle(
          fontFamily: 'Mintyou',
          fontSize: 25,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: HexColor('F2F2F2'),
        primary: Colors.black,
        side: const BorderSide(),
        textStyle: TextStyle(
          fontFamily: 'Mintyou',
          fontSize: 25,
        ),
      ),
    ),
    dialogTheme: DialogTheme(
        contentTextStyle: TextStyle(
          fontFamily: 'Mintyou',
          fontSize: 14,
          color: Colors.black,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Mintyou',
          fontSize: 20,
          color: Colors.black,
        )),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CupertinoPageTransitionsBuilder(), //←変更
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
