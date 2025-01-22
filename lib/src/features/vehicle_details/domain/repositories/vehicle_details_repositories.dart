import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';

abstract interface class VehicleDetailsRepository {
  Future<VehicleDetails> getVehicleDetails(String vehicleId);
}
