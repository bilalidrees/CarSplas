import 'package:hiltonSample/src/model/Service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hiltonSample/src/model/Car.dart';

class Location {
  @JsonKey(name: 'Address')
  String address;
  @JsonKey(name: 'Lat')
  String lat;
  @JsonKey(name: 'Lng')
  String lng;

  Location({this.address, this.lat, this.lng});

  factory Location.fromJson(Map<dynamic, dynamic> json) {
    return Location(
      address: json['Address'] as String,
      lat: json['Lat'] as String,
      lng: json['Lng'] as String,
    );
  }

//
  Map<String, dynamic> toJson() => _locationToJson(this);

  Map<String, dynamic> _locationToJson(Location instance) => <String, dynamic>{
        'Address': instance.address,
        'Lat': instance.lat,
        'Lng': instance.lng,
      };
}
