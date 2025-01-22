import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/entities/user.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/core/repository/user_repository.dart';
import 'package:vrhaman/src/core/usecase/usecase.dart';

class UserUsecase implements UseCase<User, User> {
  final UserRepository userRepository;
  UserUsecase({required this.userRepository});
  @override
  Future<Either<Failure, User>> call(User user) async {
    return await userRepository.getUserData(user);
  }
}