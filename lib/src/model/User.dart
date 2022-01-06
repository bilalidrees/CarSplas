import 'package:json_annotation/json_annotation.dart';

//part 'User.g.dart';

class User {
  String name;
  String image;
  String id;
  String email;
  String number;

  User({this.name, this.image, this.id, this.email, this.number});

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
        name: json["name"],
        image: json["image"],
        id: json["id"],
        email: json["email"],
        number: json["number"]);
  }

  Map<String, dynamic> toJson() => _userToJson(this);

  Map<String, dynamic> _userToJson(User instance) => <String, dynamic>{
        'name': instance.name,
        'image': instance.image,
        'id': instance.id,
        'email': instance.email,
        'number': instance.number,
      };
}
