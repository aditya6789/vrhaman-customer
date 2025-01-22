import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/entities/user.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/core/usecase/user_usecases.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserUsecase userUsecase;

  UserCubit({required this.userUsecase}) : super(UserInitial());
    final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  

  Future<void> getUserData(User user) async {
    emit(UserLoading());
    final Either<Failure, User> result = await userUsecase(user);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }
}
