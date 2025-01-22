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
      final vehicleData = json['vehicle_id'] is Map 
          ? json['vehicle_id'] as Map<String, dynamic>
          : {'_id': json['vehicle_id'], 'name': '', 'images': []};

      final vendorData = json['vendor_id'] is Map
          ? json['vendor_id'] as Map<String, dynamic>
          : {'_id': json['vendor_id'], 'business_name': '', 'business_address': ''};

      final customerId = json['customer_id'] is Map
          ? (json['customer_id'] as Map<String, dynamic>)['_id']
          : json['customer_id'];

      return BookingVehicleModel(
        id: json['_id'] ?? '',
        customerId: customerId ?? '',
        vehicleId: vehicleData['_id'] ?? '',
        vehicleName: vehicleData['vehicle_id']['name'] ?? '',
        vehicleImages: List<dynamic>.from(vehicleData['images'] ?? []),
        vendorId: vendorData['_id'] ?? '',
        vendorBusinessName: vendorData['business_name'] ?? '',
        vendorBusinessAddress: vendorData['business_address'] ?? '',
        vendorPhone: vendorData['user_id']['phone'] ?? '',
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
