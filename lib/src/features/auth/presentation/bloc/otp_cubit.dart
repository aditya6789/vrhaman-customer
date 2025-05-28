import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrhaman/src/app.dart';
import 'package:vrhaman/src/features/auth/presentation/bloc/login_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Add this import
import 'package:vrhaman/src/features/auth/domain/usecase/authUseCase.dart'; // Add this import

// Otp State classes
class OtpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpValidationSuccess extends OtpState {
  final String message;

  OtpValidationSuccess(this.message);

  // @override
  // List<Object?> get props => [message, userData];
}

class OtpResendLoading extends OtpState {}

class OtpValidationSuccessNewUser extends OtpState {
  final String message;
  // final Map<String, dynamic> userData;

  OtpValidationSuccessNewUser(this.message);

  // @override
  // List<Object?> get props => [message, ];
}

class OtpResendSuccess extends OtpState {
  final String message;

  OtpResendSuccess(this.message);
}

class OtpValidationFailure extends OtpState {
  final String error;

  OtpValidationFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Cubit class
class OtpCubit extends Cubit<OtpState> {
  final VerificationUseCase verificationUseCase;

  OtpCubit(this.verificationUseCase) : super(OtpInitial());

  
  // Method to validate OTP
  Future<void> validateOtp(BuildContext context, String otp) async {
    emit(OtpLoading());
    final String phone = context.read<LoginCubit>().phoneController.text;
    final VerificationParams params = VerificationParams(phone: phone, otp: otp);
    final result = await verificationUseCase(params);

    result.fold(
      (failure) => emit(OtpValidationFailure('Invalid OTP')),
      (verification) async {
        // final userData = verification.userData;
        // final accessToken = verification.accessToken;
        // final refreshToken = verification.refreshToken;
        // print('User verified successfully: $userData $accessToken $refreshToken');

        // try {
        //   final prefs = await SharedPreferences.getInstance();
        //   await prefs.setString('accessToken', accessToken);
        //   await prefs.setString('refreshToken', refreshToken);
        //   await prefs.setString('userData', json.encode(userData));
        //   print('AccessToken, RefreshToken, and UserData stored successfully');
        // } catch (e) {
        //   print('Error storing data in SharedPreferences: $e');
        //   emit(OtpValidationFailure('Error storing data in SharedPreferences: $e'));
        //   return;
        // }

        emit(OtpValidationSuccess('OTP validated successfully'));
      },
    );
  }
}
