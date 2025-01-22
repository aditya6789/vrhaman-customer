import 'package:dio/dio.dart';


import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrhaman/constants.dart';

Future<String> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('accessToken') ?? '';
  return token;
}

Future<Response> postRequest(String endpoint, Map<String, dynamic> body,
    {Map<String, String>? headers}) async {
  final Dio dio = Dio();
  final String token = await getToken();
  final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  headers?.forEach((key, value) => defaultHeaders[key] = value);

  return await dio.post(
    '${API_URL}/$endpoint',
    data: json.encode(body),
    options: Options(headers: defaultHeaders),
  );
}

Future<Response> putRequest(String endpoint, Map<String, dynamic> body,
    {Map<String, String>? headers}) async {
  final Dio dio = Dio();
  final String token = await getToken();
  final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  // Ensure a return statement
  return dio.put('${API_URL}/$endpoint', data: body, options: Options(headers: defaultHeaders));
}

Future<Response> patchRequest(String endpoint, Map<String, dynamic> body,
    {Map<String, String>? headers}) async {
  final Dio dio = Dio();
  final String token = await getToken();
  final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  headers?.forEach((key, value) => defaultHeaders[key] = value);

  return await dio.patch(
    '${API_URL}/$endpoint',
    data: json.encode(body),
    options: Options(headers: defaultHeaders),
  );
}


Future<Response> deleteRequest(String endpoint,
    {Map<String, String>? headers}) async {
  final Dio dio = Dio();
  final String token = await getToken();
  final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  headers?.forEach((key, value) => defaultHeaders[key] = value);

  return await dio.delete(
    '${API_URL}/$endpoint',
    options: Options(headers: defaultHeaders),
  );
}

Future<Response> getRequest(String endpoint,
    {Map<String, String>? headers}) async {
  final Dio dio = Dio();
  final String token = await getToken();
  final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  headers?.forEach((key, value) => defaultHeaders[key] = value);

  print("endpoint: ${API_URL}/$endpoint");

  return await dio.get(
    '${API_URL}/$endpoint',
    options: Options(headers: defaultHeaders),
  );
  
}

Future<Response> postMultipartFormData(String endpoint, FormData formData,
    {Map<String, String>? headers}) async {
  final Dio dio = Dio();
  final String token = await getToken();
  final Map<String, String> defaultHeaders = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'multipart/form-data'
  };
  headers?.forEach((key, value) => defaultHeaders[key] = value);

  return await dio.put(
    '${API_URL}$endpoint',
    
    data: formData,
    options: Options(headers: defaultHeaders),
  );
  
}