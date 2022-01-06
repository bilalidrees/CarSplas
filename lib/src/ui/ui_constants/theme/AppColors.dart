import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  BuildContext _context;
  static AppColors _instance;

  AppColors(_context) {
    this._context = _context;
  }

  factory AppColors.of(BuildContext context) {
    if (_instance == null) _instance = AppColors(context);
    return _instance;
  }

//  Color _mainColor = Color(0xFFFF4E6A);
  Color _mainColor = Color(0xFF43c3ef);
  Color _secondColor = Color(0xFF70defc);
  Color _facebookColor = Color(0xFF3b5998);
  Color _accentColor = Color(0xFF8C98A8);

  static Color black = const Color(0x42000000);
  static Color white = const Color(0xFFFFFFFF);

  static Color appScreenColor = const Color(0xFFf4f7fc);
  static Color dropDownItems = const Color(0xFFd8d8d8);

  static Color buttonDisableColor = const Color(0xFF70defc).withOpacity(0.5);





  static Color customButtonColorYellow = const Color(0xFFFFCC00);

  static const Color deliveryStatusHighlightColor = const Color(0xFF005295);
  static const Color dim_grey = const Color(0xFF6f6f6f);

  static Color fbColor = const Color(0xFF3b5998);

  static Color whiteSmoke = const Color(0xFFf4f7f9);
  static Color selectedButtonColor = const Color(0xFF8bc53f);
  static Color timberWolf = const Color(0xFFd8d8d8);

  static Color buttonDisableTextColor = const Color(0xFF6f6f6f);

  // ignore: non_constant_identifier_names
  static Color buttonDenied = const Color(0xFFc8171d);
  static Color textHighlightColor = const Color(0xFF3b5998);
  static Color buttonSaveColor = const Color(0xFF004b8f);

  Color setOpacity(double opacity) {
    return customButtonColorYellow.withOpacity(opacity);
  }

  Color mainColor(double opacity) {
    return this._mainColor.withOpacity(opacity);
  }

  Color secondColor(double opacity) {
    return this._secondColor.withOpacity(opacity);
  }

  Color facebookColor(double opacity) {
    return this._facebookColor.withOpacity(opacity);
  }

  Color accentColor(double opacity) {
    return this._accentColor.withOpacity(opacity);
  }

}
