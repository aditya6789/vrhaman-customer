import 'package:vrhaman/src/features/home/domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  VehicleModel({
    required super.id,
    super.vendorId,
    super.vehicleId,
    required super.name,
    required super.images,
    required super.dailyRate,
    super.availableDelivery,
    super.availabilityStatus,
    super.vehicleDetails,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    try {
      final vehicleDetails = json['vehicleDetails'] ?? json['vehicle_id'];
      final name = vehicleDetails is Map ? vehicleDetails['name'] : '';
      
      List<String> imagesList = [];
      if (json['images'] is List) {
        imagesList = List<String>.from(json['images']);
      }

      return VehicleModel(
        id: json['_id'] ?? '',
        vendorId: json['vendor_id'],
        vehicleId: json['vehicle_id'],
        name: name,
        images: imagesList,
        dailyRate: (json['daily_rate'] ?? 0).toDouble(),
        availableDelivery: json['available_delivery']?.toString(),
        availabilityStatus: json['availability_status']?.toString(),
        vehicleDetails: vehicleDetails is Map ? Map<String, dynamic>.from(vehicleDetails) : null,
      );
    } catch (e, stackTrace) {
      print('Error parsing vehicle JSON: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'name': name,
      'images': images,
      'dailyPrice': dailyRate,
      'availableDelivery': availableDelivery,
      'availabilityStatus': availabilityStatus,
    };
  }

  Vehicle toEntity() => this;
}
