import 'package:json_annotation/json_annotation.dart';

//part 'Service.g.dart';


class Service {
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'price')
  String price;
  bool isSelected;

  Service({this.name, this.description, this.price, this.isSelected});

  factory Service.fromJson(Map<dynamic, dynamic> json) {
    return Service(
        name: json["name"],
        description: json["description"],
        price: json["price"]);
  }

  Map<String, dynamic> toJson() => _servicesToJson(this);

  Map<String, dynamic> _servicesToJson(Service instance) => <String, dynamic>{
        'name': instance.name,
        'description': instance.description,
        'price': instance.price,
      };
}
