import 'package:anonim_io/src/core/utils/const.dart';
import 'package:anonim_io/src/core/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData get light {
    final ligtTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: _elevatedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      appBarTheme: _appBarTheme,
      textTheme: _textTheme,
    );
    return ligtTheme;
  }

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: textFieldHorizontalPadding,
      vertical: textFieldVerticalPadding,
    ),
    labelStyle: _textTheme.headline2,
    hintStyle: _textTheme.headline1,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Palette.borderColor),
      borderRadius: BorderRadius.all(Radius.circular(appRadius)),
    ),
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: Palette.borderColor),
      borderRadius: BorderRadius.all(Radius.circular(appRadius)),
    ),
  );

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Palette.mainBlue,
      textStyle: _textTheme.headline3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(appRadius),
      ),
      fixedSize: const Size(double.infinity, 48),
    ),
  );

  static final AppBarTheme _appBarTheme = AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ),
    iconTheme: const IconThemeData(color: Palette.textColor),
    titleTextStyle: _textTheme.headline3,
    titleSpacing: 0,
  );

  static const TextTheme _textTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Palette.hintColor,
    ),
    headline2: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Palette.textColor,
    ),
    headline3: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Palette.textColor,
    ),
  );
}
