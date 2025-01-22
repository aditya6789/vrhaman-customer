import 'package:dio/dio.dart';
import 'package:vrhaman/src/core/error/exceptions.dart';
import 'package:vrhaman/src/features/vehicle_details/data/model/vehicleDetailsModel.dart';
// import 'package:vrhaman/src/features/bike_details/domain/entities/vehicleDetailsModel.dart';

// import 'package:vrhaman/src/features/home/data/models/vehicleModel.dart';
import 'package:vrhaman/src/utils/api_response.dart';

abstract interface class VehicleDetailsDataSource {
  Future<VehicleDetailsModel> getVehicleDetails(String vehicleId);
}

class VehicleDetailsDataSourceImpl implements VehicleDetailsDataSource {
  final Dio _dio = Dio();

  @override
  Future<VehicleDetailsModel> getVehicleDetails(String vehicleId) async {
    // print('vehicleId2: $vehicleId');

    try {
      
      final response = await getRequest('vehicles/vehicle-details?id=$vehicleId');
      print('response 2: ${response.data}');
      // print('response 2: ${response.data}');
      if (response.statusCode == 200) {
  if (response.data != null && response.data['data'] != null && response.data['data']['vendorVehicle'] != null) {
    print('response: ${response.data['data']['vendorVehicle']}');
    return VehicleDetailsModel.fromJson(response.data['data']['vendorVehicle'] as Map<String, dynamic>);
  } else {
    throw ServerException('Unexpected response structure');
  }
} else {
  throw ServerException(response.data['message'] as String);
}

    } catch (e) {
      print('response error: $e');
      throw ServerException(e.toString());
    }

   
  }
}

