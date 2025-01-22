import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/home/domain/entities/vehicle.dart';
import 'package:vrhaman/src/features/home/domain/repositories/home_repositories.dart';

class GetAllVehiclesUseCase {
  final HomeRepository repository;

  GetAllVehiclesUseCase(this.repository);

  Future<Either<Failure, List<Vehicle>>> call() async {
    return await repository.getAllVehicles();
  }
}