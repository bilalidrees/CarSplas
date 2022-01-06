import 'package:hiltonSample/src/bloc/utility/AppUtility.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/model/Car.dart';
import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/bloc/utility/SessionClass.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';

import '../../../../route_generator.dart';
import '../../../bloc/utility/AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';
import 'package:hiltonSample/src/ui/ui_constants/ImageAssetsResolver.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) async {
      await SessionClass.getInstance();
      navigateToMainScreen();
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            color: AppColors.appScreenColor,
            child: Image.asset(
              ImageAssetsResolver.SPLASH_GIF,
              height: AppConfig.of(context).appHeight(100),
              width: AppConfig.of(context).appHeight(100),
              fit: BoxFit.contain,
            )),
      ),
    );
  }

  void navigateToMainScreen() async {
    List<dynamic> responseData = await AppUtility.getRootBundle();
    AppUtility.availableCars =
        await (responseData).map((i) => Car.fromJson(i)).toList();
    AppUtility.companiesName = await AppUtility.getCompaniesName();
    AppUtility.companiesName.sort((a, b) => a.compareTo(b));
    User user = await SharedPref.createInstance().getCurrentUser();
    if (user != null) {
      Navigator.of(context).pushReplacementNamed(RouteNames.LOCATION);
    } else {
      Navigator.of(context).pushReplacementNamed(RouteNames.LOGIN);
    }
  }
}
