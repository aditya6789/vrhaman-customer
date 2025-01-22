import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();
  factory UserPreferences() => _instance;
  UserPreferences._internal();

  static const String _keyUserId = 'userId';
  static const String _keyUserToken = 'userToken';
  static const String _keyUserEmail = 'userEmail';
  static const String _keyUserPhone = 'userPhone';
  static const String _keyUserName = 'userName';
  static const String _keyActiveBookingId = 'activeBookingId';

  Future<void> setUserId(String? userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userId != null) {
      await prefs.setString(_keyUserId, userId);
    } else {
      await prefs.remove(_keyUserId);
    }
  }

  Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  Future<void> setUserToken(String? token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString(_keyUserToken, token);
    } else {
      await prefs.remove(_keyUserToken);
    }
  }

  Future<String?> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserToken);
  }

  Future<void> setUserEmail(String? email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (email != null) {
      await prefs.setString(_keyUserEmail, email);
    } else {
      await prefs.remove(_keyUserEmail);
    }
  }

  Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  Future<void> setUserPhone(String? phone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (phone != null) {
      await prefs.setString(_keyUserPhone, phone);
    } else {
      await prefs.remove(_keyUserPhone);
    }
  }

  Future<String?> getUserPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserPhone);
  }

  Future<void> setUserName(String? name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (name != null) {
      await prefs.setString(_keyUserName, name);
    } else {
      await prefs.remove(_keyUserName);
    }
  }

  Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  Future<void> setActiveBookingId(String? bookingId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (bookingId != null) {
      await prefs.setString(_keyActiveBookingId, bookingId);
    } else {
      await prefs.remove(_keyActiveBookingId);
    }
  }

  Future<String?> getActiveBookingId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyActiveBookingId);
  }

  Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserToken);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserPhone);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyActiveBookingId);
  }
} 