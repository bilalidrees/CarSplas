import 'package:hiltonSample/src/ui/pages/auth/LoginScreen.dart';
import 'package:hiltonSample/src/ui/pages/auth/SignUpScreen.dart';
import 'package:hiltonSample/src/ui/pages/main/MainPage.dart';
import 'package:hiltonSample/src/ui/pages/user/LocationScreen.dart';
import 'src/app.dart';
import 'package:hiltonSample/src/ui/pages/main/SplashScreen.dart';
import 'package:hiltonSample/src/ui/pages/other_module/MainPageNavigator.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final ScreenArguments args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => RouteAwareWidget("/", child: SplashScreen()));
      case RouteNames.LOGIN:
        return MaterialPageRoute(
            builder: (_) =>
                RouteAwareWidget(RouteNames.LOGIN, child: LoginScreen()));
      case RouteNames.SIGN_UP:
        return MaterialPageRoute(
            builder: (_) =>
                RouteAwareWidget(RouteNames.SIGN_UP, child: SignUpScreen()));
      case RouteNames.LOCATION:
        return MaterialPageRoute(
            builder: (_) =>
                RouteAwareWidget(RouteNames.LOCATION, child: LocationScreen()));
      case RouteNames.MAINPAGE:
        return MaterialPageRoute(
            builder: (_) => RouteAwareWidget(
              RouteNames.MAINPAGE,
              child: MainPage(
                  currentPage: args.currentPage,
                  currentTitle: args.message),
            ));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

class RouteNames {
  static const String SPLASH = "/welcome";
  static const String MAINPAGE = "/MainPage";
  static const String LOGIN = "/Login";
  static const String SIGN_UP = "/SIGNUP";
  static const String CAR_LIST = "/CAR_LIST";
  static const String LOCATION= "/LOCATION";
}
