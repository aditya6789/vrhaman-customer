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
    super.averageRating,
    super.seats,
    super.fuelType,
    super.enginecc,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    try {
      final vehicleDetails = json['vehicleDetails'] ?? json['vehicle_id'];
      final name = json['name'] ?? (vehicleDetails is Map ? vehicleDetails['name'] : '') ?? '';
      final seats = json['seats'] ?? (vehicleDetails is Map ? vehicleDetails['seats'] : 0);
      final fuelType = json['fuel_type'] ?? (vehicleDetails is Map ? vehicleDetails['fuel_type'] : '');
      final enginecc = json['engine_cc'] ?? (vehicleDetails is Map ? vehicleDetails['engine_cc'] : 0);
      
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
        averageRating: json['average_rating']?.toDouble() ?? 0.0,
        vehicleDetails: vehicleDetails is Map ? Map<String, dynamic>.from(vehicleDetails) : null,
        seats: seats ?? 0,
        fuelType: fuelType ?? '',
        enginecc: enginecc ?? '',
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
