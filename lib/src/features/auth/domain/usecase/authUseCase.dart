import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/usecase/usecase.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:vrhaman/src/features/auth/domain/entities/login.dart';
import 'package:vrhaman/src/features/auth/domain/entities/verification.dart';

class LoginUseCase implements UseCase<String, String> {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  @override
  Future<Either<Failure, String>> call(String phone) async {
    return await authRepository.login(phone: phone);
  }
}

class VerificationUseCase implements UseCase<Verification, VerificationParams> {
  final AuthRepository authRepository;

  VerificationUseCase(this.authRepository);

  @override
  Future<Either<Failure, Verification>> call(VerificationParams params) async {
    return await authRepository.loginVerification(phone: params.phone, otp: params.otp);
  }

  
}
class ResendOtpUseCase implements UseCase<void, String> {
    final AuthRepository authRepository;
  
    ResendOtpUseCase(this.authRepository);
  
    @override
    Future<Either<Failure, void>> call(String phone) async {
      return await authRepository.resendOtp(phone: phone);
    }
}
class VerificationParams {
  final String phone;
  final String otp;

  VerificationParams({required this.phone, required this.otp});
}
