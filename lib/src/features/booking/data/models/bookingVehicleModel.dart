import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';

class BookingVehicleModel extends BookingVehicle {
  BookingVehicleModel({
    required String id,
    required String customerId,
    required String vehicleId,
    required String vehicleName,
    required List<dynamic> vehicleImages,
    required String vendorId,
    required String vendorBusinessName,
    required String vendorBusinessAddress,
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String vendorPhone,
    required String vendorAlternativePhone,
    required String payment_type,
    required DateTime startDate,
    required String startTime,
    required DateTime endDate,
    required String status,
    required int totalPrice,
    required String rentalPeriod,
  }) : super(
          id: id,
          customerId: customerId,
          vehicleId: vehicleId,
          vehicleName: vehicleName,
          vehicleImages: vehicleImages,
          vendorId: vendorId,
          vendorBusinessName: vendorBusinessName,
          vendorBusinessAddress: vendorBusinessAddress,
          pickupAddress: pickupAddress,
          pickupLatitude: pickupLatitude,
          pickupLongitude: pickupLongitude,
          vendorPhone: vendorPhone,
          vendorAlternativePhone: vendorAlternativePhone,
          payment_type: payment_type,
          startDate: startDate,
          startTime: startTime,
          endDate: endDate,
          status: status,
          totalPrice: totalPrice,
          rentalPeriod: rentalPeriod,
        );

  factory BookingVehicleModel.fromJson(Map<String, dynamic> json) {
    try {
      // Safely handle vehicle_id which could be a Map or String
      Map<String, dynamic> vehicleData;
      if (json['vehicle_id'] is Map) {
        // Convert dynamic Map to Map<String, dynamic>
        vehicleData = Map<String, dynamic>.from(json['vehicle_id'] as Map);
      } else {
        vehicleData = {'_id': json['vehicle_id'], 'name': '', 'images': []};
      }

      // Safely handle vendor_id which could be a Map, String, or null
      Map<String, dynamic> vendorData;
      if (json['vendor_id'] is Map) {
        // Convert dynamic Map to Map<String, dynamic>
        vendorData = Map<String, dynamic>.from(json['vendor_id'] as Map);
      } else {
        vendorData = {
          '_id': json['vendor_id'] ?? '',
          'business_name': '',
          'business_address': '',
          'user_id': {'phone': ''},
          'alternate_phone': '',
          'pickup_location': {'latitude': 0.0, 'longitude': 0.0, 'address': ''},
        };
      }

      // Safely handle customer_id which could be a Map or String
      String customerId;
      if (json['customer_id'] is Map) {
        final customerMap = Map<String, dynamic>.from(json['customer_id'] as Map);
        customerId = customerMap['_id'] ?? '';
      } else {
        customerId = json['customer_id'] ?? '';
      }

      // Safely handle nested vehicle data
      Map<String, dynamic>? vehicleIdData;
      if (vehicleData['vehicle_id'] is Map) {
        vehicleIdData = Map<String, dynamic>.from(vehicleData['vehicle_id'] as Map);
      }

      // Safely handle nested user data in vendor
      Map<String, dynamic>? userData;
      if (vendorData['user_id'] is Map) {
        userData = Map<String, dynamic>.from(vendorData['user_id'] as Map);
      }

      // Safely handle pickup location
      Map<String, dynamic>? pickupLocation;
      if (vendorData['pickup_location'] is Map) {
        pickupLocation = Map<String, dynamic>.from(vendorData['pickup_location'] as Map);
      }

      return BookingVehicleModel(
        id: json['_id'] ?? '',
        customerId: customerId,
        vehicleId: vehicleData['_id'] ?? '',
        vehicleName: vehicleIdData?['name'] ?? '',
        vehicleImages: List<dynamic>.from(vehicleData['images'] ?? []),
        vendorId: vendorData['_id'] ?? '',
        vendorBusinessName: vendorData['business_name'] ?? '',
        vendorBusinessAddress: vendorData['business_address'] ?? '',
        pickupAddress: pickupLocation?['address'] ?? '',
        pickupLatitude: (pickupLocation?['latitude'] is num) 
            ? (pickupLocation!['latitude'] as num).toDouble() 
            : 0.0,
        pickupLongitude: (pickupLocation?['longitude'] is num) 
            ? (pickupLocation!['longitude'] as num).toDouble() 
            : 0.0,
        vendorPhone: userData?['phone'] ?? '',
        vendorAlternativePhone: vendorData['alternate_phone'] ?? '',
        payment_type: json['payment_type'] ?? '',
        startDate: DateTime.parse(json['start_date'] ?? DateTime.now().toIso8601String()),
        startTime: json['start_time'] ?? '',
        endDate: DateTime.parse(json['end_date'] ?? DateTime.now().toIso8601String()),
        status: json['status'] ?? '',
        totalPrice: (json['total_price'] is int)
            ? json['total_price']
            : int.tryParse(json['total_price']?.toString() ?? '0') ?? 0,
        rentalPeriod: json['duration'] ?? '',
      );
    } catch (e) {
      print("Error in fromJson: $e");
      print("JSON data: $json");
      rethrow;
    }
  }
}
