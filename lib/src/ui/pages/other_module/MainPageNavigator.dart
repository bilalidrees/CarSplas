import 'package:flutter/cupertino.dart';

class ScreenArguments<T> {
  final int tab;
  final Widget currentPage;
  final String message;
  final bool flag;
  final T data;
  final T secondData;

  ScreenArguments(
      {this.tab,
      this.currentPage,
      this.message,
      this.data,
      this.secondData,
      this.flag});
}
