import 'dart:convert';

import 'package:hiltonSample/src/model/User.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPref();

  SharedPref.createInstance();

  setCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      Map<String, dynamic> result = user.toJson();
      String jsonUser = jsonEncode(result);
      prefs.setString(Strings.CURRENT_USER, jsonUser);
    } else {
      prefs.setString(Strings.CURRENT_USER, null);
    }
  }

  Future<User> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(Strings.CURRENT_USER);
    if (result != null) {
      Map<String, dynamic> map = jsonDecode(result);
      return User.fromJson(map);
    } else
      return null;
  }
}
