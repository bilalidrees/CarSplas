import 'package:json_annotation/json_annotation.dart';

//part 'Car.g.dart';

class Car {
  @JsonKey(name: 'Id')
  String id;
  @JsonKey(name: 'Image')
  String image;
  @JsonKey(name: 'Company')
  String company;
  @JsonKey(name: 'Model')
  String car;
  @JsonKey(name: 'CC')
  String cc;
  @JsonKey(name: 'Version')
  String version;
  @JsonKey(name: 'Type')
  String type;

  Car(
      {this.id,
      this.image,
      this.company,
      this.car,
      this.cc,
      this.version,
      this.type});

  factory Car.fromJson(Map<dynamic, dynamic> json) {
    return Car(
        id: json["Id"],
        image: json["Image"],
        company: json["Company"],
        car: json["Model"],
        cc: json["CC"],
        version: json["Version"],
        type: json["Type"]);
  }

  Map<String, dynamic> toJson() => _carToJson(this);

  Map<String, dynamic> _carToJson(Car instance) => <String, dynamic>{
        'Id': instance.id,
        'Image': instance.image,
        'Company': instance.company,
        'Model': instance.car,
        'CC': instance.cc,
        'Version': instance.version,
        'Type': instance.type,
      };
}
