import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrhaman/src/core/model/userModel.dart';
import 'package:vrhaman/src/utils/api_response.dart';

abstract interface class UserDataSource{
  Future<UserModel> getUserData(UserModel userModel);
}

class UserDataSourceImpl implements UserDataSource{
  @override
  Future<UserModel> getUserData(UserModel userModel) async {
    print(userModel.toJson());
    // print(userModel.toJson());
    try {
      final formData = FormData.fromMap(userModel.toJson());
      print(formData);
      final response = await patchRequest('users/', userModel.toJson());
      if (response.statusCode == 200) {
        print(response.data);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', json.encode(response.data['data']));
        return UserModel.fromJson(response.data['data']);
    
      } else {
        print(response.data);
        throw Exception(response.data['message']);
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch user data: $e');
    }
  }
}
