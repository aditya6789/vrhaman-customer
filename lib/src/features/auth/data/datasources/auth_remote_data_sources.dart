import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/core/error/exceptions.dart';
import 'package:vrhaman/src/features/auth/data/model/authModel.dart';
import 'package:vrhaman/src/features/auth/data/model/verificationModel.dart';
import 'package:vrhaman/src/utils/api_response.dart';
import 'package:dio/dio.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> sendOtp(AuthModel authModel);
  Future<void> verifyOtp(VerificationModel verificationModel);
  Future<String> resendOtp(AuthModel authModel);

}

String ? requestId;

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio = Dio();
  
  @override
  Future<String > sendOtp(AuthModel authModel) async {
    print('authModel: ${authModel.phone}');
   try {
     final response = await _dio.post(
      '${API_URL}auth/send-otp',
      data: {
        'phone_number': authModel.phone,
      }
    );
 
   if(response.statusCode == 200){
    print('response: ${response.data}');
    requestId = response.data['data']['requestId'];
    print('requestId: $requestId');
    return 'Sent OTP Successfully';

   }else{
    throw ServerException('Failed to send OTP: ${response.statusCode}');
   }
    
   } catch (e) {
    print(e);
    throw ServerException(e.toString());
     
   }
  }

  @override
  Future<void> verifyOtp(VerificationModel verificationModel) async {
    print('verificationModel: ${verificationModel.phone} ${verificationModel.otp}');
   try {
     final response = await _dio.post(
      '${API_URL}auth/validate-otp/',
      data: {
        'phone_number': verificationModel.phone,
        'otp': verificationModel.otp,
        'requestId': requestId,
      },
    
    );
    print('response: ${response}');
    if (response.statusCode == 201){
       print('response: ${response.data}');
       final Map<String, dynamic> responseData = response.data['data'];
        final String accessToken = responseData['token'];
        final Map<String, dynamic> userData = responseData['user'];
        print('User verified successfully: $userData $accessToken');

        try {
          final prefs = await SharedPreferences.getInstance();
          bool tokenStored = await prefs.setString('accessToken', accessToken);
          bool userStored =
              await prefs.setString('userData', json.encode(userData));

          if (tokenStored && userStored) {
            print('AccessToken and UserData stored successfully');
          } else {
            print('Failed to store AccessToken or UserData');
          }
        } catch (e) {
          print('Error storing data in SharedPreferences: $e');
         
          return;
        }

    }
    if(response.statusCode == 200){
      print('response: ${response.data}');
       final Map<String, dynamic> responseData = response.data['data'];
        final String accessToken = responseData['token'];
        final Map<String, dynamic> userData = responseData['user'];
        print('User verified successfully: $userData $accessToken');

        try {
          final prefs = await SharedPreferences.getInstance();
          bool tokenStored = await prefs.setString('accessToken', accessToken);
          bool userStored =
              await prefs.setString('userData', json.encode(userData));

          if (tokenStored && userStored) {
            print('AccessToken and UserData stored successfully');
          } else {
            print('Failed to store AccessToken or UserData');
          }
        } catch (e) {
          print('Error storing data in SharedPreferences: $e');
         
          return;
        }

    }
    print(response.data);
    return response.data;
     
   } catch (e) {
    print(e);
    throw ServerException(e.toString());
     
   }
  }

  @override
  Future<String> resendOtp(AuthModel authModel) async {
    try {
      final response = await _dio.post(
        '${API_URL}auth/resend-otp',
        data: {
          'phone': authModel.phone,
        }
      );
      if (response.statusCode == 200) {
        print('response: ${response.data}');
        final otp = response.data['data']['otp'];
        return otp;
      }
      throw ServerException('Failed to resend OTP: ${response.statusCode}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

