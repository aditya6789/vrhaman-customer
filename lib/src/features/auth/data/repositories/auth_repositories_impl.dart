import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:vrhaman/src/features/auth/data/model/authModel.dart';
import 'package:vrhaman/src/features/auth/data/model/verificationModel.dart';
import 'package:vrhaman/src/features/auth/domain/entities/login.dart';
import 'package:vrhaman/src/features/auth/domain/entities/verification.dart';
import 'package:vrhaman/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> login({required String phone}) async {
    try {
      final authModel = AuthModel(phone: phone);
      final otp =await remoteDataSource.sendOtp(authModel);
      return Right(otp);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Verification>> loginVerification({
    required String phone,
    required String otp,
  }) async {
    try {
      final verificationModel = VerificationModel(phone: phone, otp: otp);
      await remoteDataSource.verifyOtp(verificationModel);
      return Right(Verification(phone: phone, otp: otp));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resendOtp({required String phone}) async {
    try {
      final authModel = AuthModel(phone: phone);
      final otp = await remoteDataSource.resendOtp(authModel);
      return Right(otp); // Add this line
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
