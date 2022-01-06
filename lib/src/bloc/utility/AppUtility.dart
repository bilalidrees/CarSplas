import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:hiltonSample/src/model/Car.dart';

class AppUtility {
  static List<Car> availableCars = [];
  static List<String> companiesName = [];
  static List<String> carsName = [];
  static List<String> carsCC = [];

  static Future<List<dynamic>> getRootBundle() async {
    final String response = await rootBundle.loadString("i18n/cars.json");
    final data = await json.decode(response);
    List<dynamic> responseData = data as List<dynamic>;
    return responseData;
  }

  static Future<List<String>> getCompaniesName() async {
    List<String> companiesName = [];
    availableCars.forEach((car) {
      if (!companiesName.contains(car.company)) {
        companiesName.add(car.company);
      }
    });
    return companiesName;
  }

  static Future<List<String>> getCarsName(String companyName) async {
    List<String> carName = [];
    availableCars.forEach((car) {
      if (!carName.contains(car.car) && car.company == companyName) {
        carName.add(car.car);
      }
    });
    return carName;
  }

  static Future<List<String>> getCarsCC(
      String companyName, String carModel) async {
    List<String> carCC = [];
    availableCars.forEach((car) {
      if (!carCC.contains(car.cc) &&
          car.company == companyName &&
          car.car == carModel) {
        carCC.add(car.cc);
      }
    });
    return carCC;
  }

  static Future<String> getCurrentDate() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }
}
