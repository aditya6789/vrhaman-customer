import 'dart:convert';

import 'package:vrhaman/src/core/error/exceptions.dart';
import 'package:vrhaman/src/features/home/data/models/brandModel.dart';
import 'package:vrhaman/src/features/home/data/models/vehicleModel.dart';
import 'package:vrhaman/src/utils/api_response.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<VehicleModel>> getAllVehicles();
  Future<List<VehicleModel>> getPopularBikes();
  Future<List<VehicleModel>> getPopularCars();
  Future<List<VehicleModel>> getUserPreferredVehicles();
  Future<List<VehicleModel>> getBestDeals();
  Future<List<BrandModel>> getBrands();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<VehicleModel>> getAllVehicles() async {
    try {
      final response = await getRequest('vendor-vehicle');
      // print("sources response ${response.data}");
      // print("sources response ${response.data['data']['vehicles']}");

      if (response.statusCode == 200) {
        print("sources response ${response.data['data']['vendorVehicles']}");
        final List<dynamic> vehicleJsonList = response.data['data']['vendorVehicles'];
        final List<VehicleModel> vehicleModels = vehicleJsonList
            .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
            .toList();
        // List<VehicleModel> jsonList = json.decode(response.data['data']['vehicles']);
        // List<VehicleModel> vehicleModels = response.data['data']['vehicles'];
        print("vehicleModelLists $vehicleModels");
        return vehicleModels; // Correctly parse to List<VehicleModel>
      } else {
        throw Exception('Failed to load vehicles');
      }
    } catch (e) {
      print("sources error $e");
      throw ServerException(e.toString());
    }
  }


  @override
  Future<List<VehicleModel>> getPopularBikes() async {
    try {
      final response = await getRequest('vehicle-preference/popular-bikes');
      print('Popular Bikes Response: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> vehicles = response.data['data'];
        return vehicles.map((json) => VehicleModel.fromJson(json)).toList();
      }
      throw ServerException('Failed to load popular bikes');
    } catch (e) {
      print('Popular Bikes Error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<VehicleModel>> getPopularCars() async {
    try {
      final response = await getRequest('vehicle-preference/popular-cars');
      print('Popular Cars Response: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> vehicles = response.data['data'];
        return vehicles.map((json) => VehicleModel.fromJson(json)).toList();
      }
      throw ServerException('Failed to load popular cars');
    } catch (e) {
      print('Popular Cars Error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<VehicleModel>> getUserPreferredVehicles() async {
    try {
      final response = await getRequest('vehicle-preference/user-preferences');
      print('User Preferred Response: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> vehicles = response.data['data'] as List;
        return vehicles
            .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
            .toList();
            
      }
      return [];
    } catch (e) {
      print('User Preferred Error: $e');
      return [];
    }
  }

  @override
  Future<List<VehicleModel>> getBestDeals() async {
    try {
      final response = await getRequest('vehicle-preference/best-deals');
      print('Best Deals Response: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> vehicles = response.data['data'] as List;
        return vehicles
            .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw ServerException('Failed to load best deals');
    } catch (e) {
      print('Best Deals Error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BrandModel>> getBrands() async {
    try {
      final response = await getRequest('make-model/make');
      print('Brands Response: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> brands = response.data['data']['makes'] as List;
        return brands.map((json) => BrandModel.fromJson(json)).toList();
      }
      throw ServerException('Failed to load brands');
    } catch (e) {
      print('Brands Error: $e');
      throw ServerException(e.toString());
    }
  }
}
