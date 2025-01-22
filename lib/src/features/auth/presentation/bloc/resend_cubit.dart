import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vrhaman/src/features/auth/domain/entities/login.dart';
import 'package:vrhaman/src/features/auth/domain/usecase/authUseCase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';

// State classes
class ResendState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ResendInitial extends ResendState {}

class ResendLoading extends ResendState {}

class ResendSuccess extends ResendState {
  final String message;

  ResendSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResendFailure extends ResendState {
  final String error;

  ResendFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Cubit class
class ResendCubit extends Cubit<ResendState> {
  final ResendOtpUseCase resendOtpUseCase;

  ResendCubit(this.resendOtpUseCase) : super(ResendInitial());

  // final TextEditingController phoneController = TextEditingController();

  Future<void> sendResendOtp(String phone) async {
    emit(ResendLoading());
    final Either<Failure, void> result = await resendOtpUseCase(phone);
    result.fold(
      (failure) => emit(ResendFailure(failure.message)),
      (_) => emit(ResendSuccess('OTP sent successfully')),
    );
  }
}
