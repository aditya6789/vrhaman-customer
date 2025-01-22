
import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/auth/domain/entities/login.dart';
import 'package:vrhaman/src/features/auth/domain/entities/verification.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> login({
    required String phone,
   
  });
  Future<Either<Failure, Verification>> loginVerification({
    required String phone,
    required String otp,
  });

  Future<Either<Failure, String>> resendOtp({
    required String phone,
  });

}
