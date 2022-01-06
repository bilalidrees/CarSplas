import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class EnvironmentConfig extends InheritedWidget {
  EnvironmentConfig({
    @required this.apiBaseUrl,
    @required Widget child,
  }) : super(child: child);

  final String apiBaseUrl;

  static EnvironmentConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EnvironmentConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
