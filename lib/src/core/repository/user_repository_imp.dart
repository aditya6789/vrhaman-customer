import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/entities/user.dart';
import 'package:vrhaman/src/core/data/user_data_sources.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/core/model/userModel.dart';
import 'package:vrhaman/src/core/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSourceImpl dataSource;
  UserRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, User>> getUserData(User user) async {
    try {
      final userModel = await dataSource.getUserData(UserModel(
        name: user.name,
        email: user.email,
        gender: user.gender,
        phone: user.phone,
        profile_picture: user.profile_picture,
      ));
      final fetchedUser = User(
        phone: userModel.phone,
        name: userModel.name,
        email: userModel.email,
        gender: userModel.gender,
        profile_picture: userModel.profile_picture,
      );
      return Right(fetchedUser);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
