import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vrhaman/src/features/auth/domain/entities/login.dart';
import 'package:vrhaman/src/features/auth/domain/usecase/authUseCase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';

// State classes
class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;

  LoginSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Cubit class
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  final TextEditingController phoneController = TextEditingController();

  Future<void> sendOtp(String phone) async {
    emit(LoginLoading());
    final Either<Failure, String> result = await loginUseCase(phone);
    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (login) => emit(LoginSuccess(login)),
    );
  }
}
