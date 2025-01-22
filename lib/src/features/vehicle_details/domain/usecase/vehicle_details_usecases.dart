import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/core/usecase/usecase.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/repositories/vehicle_details_repositories.dart';

class VehicleDetailsUsecase implements UseCase<VehicleDetails, String> {
  final VehicleDetailsRepository _repository;

  VehicleDetailsUsecase(this._repository);

  @override
  Future<Either<Failure, VehicleDetails>> call(String vehicleId) async {
    try {
      final vehicleDetails = await _repository.getVehicleDetails(vehicleId);
      return Right(vehicleDetails);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}