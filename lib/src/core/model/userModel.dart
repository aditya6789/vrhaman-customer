import 'package:vrhaman/src/core/entities/user.dart';

class UserModel extends User {
  UserModel(
      {required super.name,
      required super.email,
      required super.gender,
      required super.phone,
      required super.profile_picture});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'phone': phone,
      'profile_image': profile_picture,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        email: json['email'],
        gender: json['gender'],
        phone: json['phone'],
        profile_picture: json['profile_picture']??'');
  }
}
