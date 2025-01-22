import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/home/domain/entities/vehicle.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, List<Vehicle>>> getAllVehicles();
}
