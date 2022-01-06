import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hiltonSample/route_generator.dart';
import 'package:hiltonSample/src/app.dart';
import 'package:hiltonSample/src/bloc/utility/SessionClass.dart';
import 'package:hiltonSample/src/bloc/utility/SharedPrefrence.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import '../../AppLocalizations.dart';
import 'NetworkConstant.dart';

class NetworkClientState {
  static const String URL = 'https://jsonplaceholder.typicode.com/posts';

  BuildContext _buildContext;
  static NetworkClientState networkClientState;
  SessionClass sessionClass;
  String token, apiUrl;
  Map<String, String> _headers;
  http.Client _client;
  var apiResponse;

  NetworkClientState.createInstance() {
    print("create instance");
  }

  NetworkClientState(BuildContext context) {
    _buildContext = context;
  }

  static NetworkClientState getInstance({BuildContext context}) {
    if (networkClientState == null) {
      networkClientState = NetworkClientState(context);
    }
    if (context != null) {
      networkClientState._buildContext = context;
    }
    return networkClientState;
  }

  Future<void> setSessionToken() async {
    sessionClass = await SessionClass.getInstance();
    token = sessionClass.getToken();
  }

  // set up POST request arguments

  Future<NetworkClientState> postRequest(String endpoint, String json,
      {bool isTest = true}) async {
    try {
      print(token);
      print("token is ${sessionClass.getToken()}");
      print("${sessionClass.getBaseUrl()}$endpoint");

      if (!isTest) {
        apiResponse = await http.post("endpoint", body: json, headers: {
          "Content-type": "application/json",
          "Token": sessionClass.getToken()
        });
      } else {
        //Klarna credentials
//        //String username = "PK21150_62bd2b11bcd3", password = "xhNXppTGV6YHdqeD"; //for playground
        String username = "K781225_3609c2aff2f1", password = "eEFq7c44dmlKCQMk";
        //bambora credentials
        String basicAuth =
            'Basic ' + base64Encode(utf8.encode('$username:$password'));
        apiResponse = await http.post("$endpoint",
            body: json,
            headers: <String, String>{
              "Content-Type": "application/json",
              'authorization': basicAuth
            });
      }

//          .timeout(const Duration(seconds: 4));
      print("response ${apiResponse.body}");
      if (apiResponse.statusCode == 201 || apiResponse.statusCode == 200) {
        return NetworkClientState._onSuccess(apiResponse.body, endpoint);
      } else {
        if (apiResponse.statusCode == 500)
          return NetworkClientState._onError(
              NetworkConstants.SERVER_ERROR, endpoint);
        else if (apiResponse.statusCode == 401 ||
            apiResponse.statusCode == 403) {
        } else
          return NetworkClientState._onError(
              "${apiResponse.body} ${apiResponse.statusCode}", endpoint);
      }
    } on TimeoutException catch (_) {
      return NetworkClientState._onFailure(
          Exception("Timeout occured"), endpoint);
    } on Error catch (_) {
      if (apiResponse.statusCode == 403) {
      } else {
        return NetworkClientState._onFailure(
            Exception("on error triggered"), endpoint);
      }
    } on Exception catch (exception) {
      return NetworkClientState._onFailure(exception, endpoint);
    }
  }

  Future<NetworkClientState> putRequest(
      {String endpoint, String json, bool isTest = true}) async {
    try {
      print(sessionClass.getToken());
      print("l$endpoint");

      print("hit url");
      apiResponse = await http.put("$endpoint", body: json, headers: {
        "Content-type": "application/json",
        "Token": sessionClass.getToken()
      });
//          .timeout(const Duration(seconds: 4));
      if (apiResponse.statusCode == 201 || apiResponse.statusCode == 200)
        return NetworkClientState._onSuccess(apiResponse.body, endpoint);
      else {
        if (apiResponse.statusCode == 500)
          return NetworkClientState._onError(
              NetworkConstants.SERVER_ERROR, endpoint);
        else if (apiResponse.statusCode == 401 ||
            apiResponse.statusCode == 403) {
        } else
          return NetworkClientState._onError(
              "${apiResponse.body} ${apiResponse.statusCode}", endpoint);
      }
    } on TimeoutException catch (_) {
      return NetworkClientState._onFailure(
          Exception("Timeout occured"), endpoint);
    } on Error catch (_) {
      if (apiResponse.statusCode == 401 || apiResponse.statusCode == 403) {
      } else {
        return NetworkClientState._onFailure(
            Exception("on error triggered"), endpoint);
      }
    } on Exception catch (exception) {
      return NetworkClientState._onFailure(exception, endpoint);
    }
  }

  Future<NetworkClientState> getRequest(String endpoint,
      {bool isTest = true}) async {
    try {
      apiResponse = await http.get("$endpoint", headers: {
        "Content-type": "application/json",
        "Token": sessionClass.getToken()
      });
      if (apiResponse.statusCode == 200)
        return NetworkClientState._onSuccess(apiResponse.body, endpoint);
      else {
        if (apiResponse.statusCode == 500)
          return NetworkClientState._onError(
              NetworkConstants.SERVER_ERROR, endpoint);
        else if (apiResponse.statusCode == 401 ||
            apiResponse.statusCode == 403) {
        } else
          return NetworkClientState._onError(
              "${apiResponse.body} ${apiResponse.statusCode}", endpoint);
      }
    } on Error catch (_) {
      if (apiResponse.statusCode == 401 || apiResponse.statusCode == 403) {
      } else {
        return NetworkClientState._onFailure(
            Exception("on error triggered"), endpoint);
      }
    } on Exception catch (exception) {
      return NetworkClientState._onFailure(exception, endpoint);
    }
  }

  Future<NetworkClientState> deleteRequest(
      {String endpoint, String json, bool isTest = true}) async {
    try {
      apiResponse = await http.post("$endpoint", body: json, headers: {
        "Content-type": "application/json",
        "Token": sessionClass.getToken()
      });
      if (apiResponse.statusCode == 200)
        return NetworkClientState._onSuccess(apiResponse.body, endpoint);
      else {
        if (apiResponse.statusCode == 500)
          return NetworkClientState._onError(
              NetworkConstants.SERVER_ERROR, endpoint);
        else if (apiResponse.statusCode == 401 ||
            apiResponse.statusCode == 403) {
        } else
          return NetworkClientState._onError(
              "${apiResponse.body} ${apiResponse.statusCode}", endpoint);
      }
    } on Exception catch (exception) {
      return NetworkClientState._onFailure(exception, endpoint);
    }
  }

  factory NetworkClientState._onSuccess(String response, String apiEndpoint) =
      OnSuccessState;

  factory NetworkClientState._onError(String error, String apiEndpoint) =
      OnErrorState;

  factory NetworkClientState._onFailure(Exception throwable, String endPoint) =
      OnFailureState;
}

class OnSuccessState extends NetworkClientState {
  String response, apiEndpoint;

  OnSuccessState(this.response, this.apiEndpoint) : super.createInstance();
}

class OnErrorState extends NetworkClientState {
  String error, apiEndpoint;

  OnErrorState(this.error, this.apiEndpoint) : super.createInstance();
}

class OnFailureState extends NetworkClientState {
  Exception throwable;
  String apiEndpoint;

  OnFailureState(this.throwable, this.apiEndpoint) : super.createInstance();
}
