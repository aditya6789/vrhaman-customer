import 'dart:convert';

import 'package:vrhaman/src/core/error/exceptions.dart';
import 'package:vrhaman/src/features/home/data/models/brandModel.dart';
import 'package:vrhaman/src/features/home/data/models/vehicleModel.dart';
import 'package:vrhaman/src/utils/api_response.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<VehicleModel>> getAllVehicles();
  Future<List<VehicleModel>> getPopularBikes();
  Future<List<VehicleModel>> getPopularCars();
  Future<List<VehicleModel>> getUserPreferredVehicles(String latitude, String longitude);
  Future<List<VehicleModel>> getBestDeals();
  Future<List<BrandModel>> getBrands();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<VehicleModel>> getAllVehicles() async {
    try {
      final response = await getRequest('vendor-vehicle');
      print("sources response ${response.data}");

      if (response.statusCode == 200) {
        if (response.data != null && 
            response.data['data'] != null && 
            response.data['data']['vendorVehicles'] != null) {
          final List<dynamic> vehicleJsonList = response.data['data']['vendorVehicles'];
          if (vehicleJsonList.isEmpty) {
            return [];
          }
          return vehicleJsonList
              .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        return []; // Return empty list if no data
      } else {
        print("Error status code: ${response.statusCode}");
        return []; // Return empty list on error
      }
    } catch (e) {
      print("sources error $e");
      return []; // Return empty list on error
    }
  }

  @override
  Future<List<VehicleModel>> getPopularBikes() async {
    try {
      final response = await getRequest('vehicle-preference/popular-bikes');
      print('Popular Bikes Response: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data != null && response.data['data'] != null) {
          final List<dynamic> vehicles = response.data['data'];
          return vehicles.map((json) => VehicleModel.fromJson(json)).toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      print('Popular Bikes Error: $e');
      return [];
    }
  }

  @override
  Future<List<VehicleModel>> getPopularCars() async {
    try {
      final response = await getRequest('vehicle-preference/popular-cars');
      print('Popular Cars Response: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data != null && response.data['data'] != null) {
          final List<dynamic> vehicles = response.data['data'];
          return vehicles.map((json) => VehicleModel.fromJson(json)).toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      print('Popular Cars Error: $e');
      return [];
    }
  }

  @override
  Future<List<VehicleModel>> getUserPreferredVehicles(String latitude, String longitude) async {
    try {
      final response = await getRequest('vehicle-preference/user-preferences?latitude=$latitude&longitude=$longitude');
      print('User Preferred Response: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data != null && response.data['data'] != null && response.data['data']['vehicles'] != null) {
          final List<dynamic> vehicles = response.data['data']['vehicles'] as List;
          return vehicles.map((json) {
            // Create a merged map with all necessary data
            final Map<String, dynamic> mergedData = {
              '_id': json['_id'],
              'name': json['vehicle_id']['name'],
              'images': json['images'] ?? [],
              'daily_rate': json['daily_rate'],
              'availability_status': json['availability_status'] ?? 'Not Available',
              'average_rating': json['average_rating'] ?? 0.0,
              'seats': json['vehicle_id']['seats'] ?? 0,
              'fuel_type': json['vehicle_id']['fuel_type'] ?? '',
              'engine_cc': json['vehicle_id']['engine_cc'] ?? 0,
              // Add any other fields you need from the nested structure
            };
            print('Merged Data: $mergedData');
            return VehicleModel.fromJson(mergedData);
          }).toList();
        }
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
        if (response.data != null && response.data['data'] != null) {
          final List<dynamic> vehicles = response.data['data'] as List;
          return vehicles
              .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Best Deals Error: $e');
      return [];
    }
  }

  @override
  Future<List<BrandModel>> getBrands() async {
    try {
      final response = await getRequest('make-model/make');
      // print('Brands Response: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data != null && 
            response.data['data'] != null && 
            response.data['data']['makes'] != null) {
          final List<dynamic> brands = response.data['data']['makes'] as List;
          return brands.map((json) => BrandModel.fromJson(json)).toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      print('Brands Error: $e');
      return [];
    }
  }
}
