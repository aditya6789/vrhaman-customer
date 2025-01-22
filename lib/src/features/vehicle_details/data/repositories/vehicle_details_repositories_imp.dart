import 'package:vrhaman/src/features/vehicle_details/data/datasources/vehicle_details_datasource.dart';
// import 'package:vrhaman/src/features/vehicle_details/data/model/vehicleDetailsModel.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/repositories/vehicle_details_repositories.dart';

class VehicleDetailsRepositoryImpl implements VehicleDetailsRepository {
  final VehicleDetailsDataSource _dataSource;

  VehicleDetailsRepositoryImpl(this._dataSource);

  @override
  Future<VehicleDetails> getVehicleDetails(String vehicleId) async {
    final vehicleDetailsModel = await _dataSource.getVehicleDetails(vehicleId);
    return vehicleDetailsModel;
  }
}
