import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // Method to retrieve user data from SharedPreferences
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null && userDataString.isNotEmpty) {
      final userData = json.decode(userDataString);
      return userData;
    }
    return null;
  }

  // Method to get user ID
  Future<String?> getUserId() async {
    final userData = await getUserData();
    if (userData != null && userData.containsKey('_id')) {
      return userData['_id'];
    }
    return null;
  }
}

Future<String?> getDocument() async {
  final prefs = await SharedPreferences.getInstance();
    final documentString = prefs.getString('document');

 
   if (documentString != null && documentString.isNotEmpty) {
      final document = json.decode(documentString);
      return document;
    }
    return null;
}

Future<Map<String, String>> loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final userJson = prefs.getString('userData');
  if (userJson != null) {
    final Map<String, dynamic> user = json.decode(userJson);
    final String userId = user['_id'];
    final String userName = user['full_name'];
    final String phoneNo = user['phone'];
    final String email = user['email'];
    final String profile = user['profile'] ?? '';
    final String gender = user['gender'] ?? 'Male';
    // final String profile = user['profile'];

    return {
      'userId': userId,
      'userName': userName,
      'phoneNo': phoneNo,
      'email': email,
      'profile': profile,
      'gender': gender
    };
  }
  return {
    'userId': '',
    'userName': '',
    'phoneNo': '',
    'email': "",
    'profile': '',
    'gender': ''
  };
}
