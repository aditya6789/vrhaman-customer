import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/entities/user.dart';
import 'package:vrhaman/src/core/error/failure.dart';

abstract interface class UserRepository{
  Future<Either<Failure, User>> getUserData(User user);
}