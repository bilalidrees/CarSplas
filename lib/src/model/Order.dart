import 'package:hiltonSample/src/model/Service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hiltonSample/src/model/Car.dart';

class Order {
  @JsonKey(name: 'Car')
  Car car;
  @JsonKey(name: 'Address')
  String address;
  @JsonKey(name: 'Lat')
  String lat;
  @JsonKey(name: 'Lng')
  String lng;
  @JsonKey(name: 'Date')
  String date;
  @JsonKey(name: 'Charges')
  String charges;
  @JsonKey(name: 'Services')
  List<Service> services = [];

  Order(
      {this.car,
      this.address,
      this.lat,
      this.lng,
      this.date,
      this.charges,
      this.services});

  factory Order.fromJson(Map<dynamic, dynamic> json) {
    return Order(
        car: json['Car'] == null
            ? null
            : Car.fromJson(json['Car'] as Map<dynamic, dynamic>),
        address: json['Address'] as String,
        lat: json['Lat'] as String,
        lng: json['Lng'] as String,
        date: json['Date'] as String,
        charges: json['Charges'] as String,
        services: (json['Services'] as List)
            ?.map((e) =>
                e == null ? null : Service.fromJson(e as Map<dynamic, dynamic>))
            ?.toList());
  }

//
  Map<String, dynamic> toJson() => _carToJson(this);

  Map<String, dynamic> _carToJson(Order instance) => <String, dynamic>{
        'Car': instance.car,
        'Lat': instance.lat,
        'Lng': instance.lng,
        'Address': instance.address,
        'Date': instance.date,
        'Charges': instance.charges,
        'Services': instance.services
      };
}
