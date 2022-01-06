import 'package:flutter/material.dart';
import 'package:hiltonSample/src/app.dart';
import 'package:hiltonSample/src/resource/networkConstant.dart';
import 'EnvironmentConfig.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  var configuredApp = EnvironmentConfig(
    apiBaseUrl: NetworkConstants.PRODUCTION_URL,
    child: App(),
  );
  runApp(configuredApp);
}
