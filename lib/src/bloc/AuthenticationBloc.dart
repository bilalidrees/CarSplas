import 'dart:convert';
import 'dart:io';

import 'package:rxdart/subjects.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'bloc_provider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class AuthenticationBloc implements BlocBase {
  static AuthenticationBloc _authenticationBloc;

  final loginDrawerStreamController = PublishSubject<void>();

  Stream<void> get loginDrawerStream => loginDrawerStreamController.stream;

  final forgotPasswordStreamController = BehaviorSubject<String>();

  Stream<String> get forgotPasswordStream =>
      forgotPasswordStreamController.stream;

  static AuthenticationBloc getInstance() {
    if (_authenticationBloc == null) {
      _authenticationBloc = AuthenticationBloc();
    }
    return _authenticationBloc;
  }

  @override
  void dispose() {
    loginDrawerStreamController.close();
    forgotPasswordStreamController.close();
  }
}
