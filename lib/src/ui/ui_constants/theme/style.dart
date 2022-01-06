import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'AppColors.dart';
import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';

class Styles {
  static TextStyle getDescriptionStyle({double fontSize}) {
    double _fontSize = fontSize;
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: _fontSize,
      //fontSize: 14.0,
      color: AppColors.black,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle getDrawerItemStyle(
      {Color color ,
      double fontSize = 16,
      fontWeight = FontWeight.w300}) {
    return TextStyle(
      fontFamily: 'RobotoCondensed',
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }

  static TextStyle shortDescriptionItemStyle(
      {String fontFamily = 'Roboto',
      double fontSize = 12,
      FontWeight fontWeight = FontWeight.w300}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: AppColors.black,
      fontWeight: fontWeight,
    );
  }

  static EdgeInsetsGeometry getScreenPadding(BuildContext context) {
    return EdgeInsets.only(
        left: AppConfig.of(context).appWidth(7.4),
        right: AppConfig.of(context).appWidth(7.4));
  }
}
