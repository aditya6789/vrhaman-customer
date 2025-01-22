import 'package:vrhaman/src/features/wishlist/domain/entities/wishlist.dart';

class WishlistModel extends Wishlist{
  WishlistModel({
    required super.id,
    required super.vehicleId,
    required super.vehicleName,
    required super.vehicleImage,
    required super.vehicleDailyRate,
    required super.vehicleTopSpeed,
    required super.vehicleMileage,
    required super.vehicleEngineCc,
    required super.vehicleAvailabilityStatus,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['_id'],
      vehicleId: json['vehicle_id']['_id'],
      vehicleName: json['vehicle_id']['name'],
      vehicleImage: json['images'],
      vehicleDailyRate: json['daily_rate'],
      vehicleTopSpeed: json['vehicle_id']['top_speed'],
      vehicleMileage: json['vehicle_id']['mileage'],
      vehicleEngineCc: json['vehicle_id']['engine_cc'],
      vehicleAvailabilityStatus: json['available_delivery'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'vehicleImage': vehicleImage,
    };
  }
}