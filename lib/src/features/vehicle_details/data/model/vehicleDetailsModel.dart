import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';

class VehicleDetailsModel extends VehicleDetails {
  VehicleDetailsModel(
      {required super.id,
      required super.name,
      required super.vendorId,
      required super.bussinessName,
      required super.bussinessAddress,
      required super.dailyPrice,
      required super.twoDayPrice,
      required super.threeDayPrice,
      required super.fourDayPrice,
      required super.fiveDayPrice,
      required super.sixDayPrice,
      required super.weeklyPrice,
      required super.twoWeekPrice,
      required super.threeWeekPrice,
      required super.monthlyPrice,
      required super.twoMonthPrice,
      required super.threeMonthPrice,
      required super.availableDelivery,
      required super.deliveryFees,
      required super.availabilityStatus,
      required super.images,
      required super.year,
      required super.variant,
    
      required super.engineCc,
      required super.fuelType,
      required super.bodyType,
      required super.mileage,
      required super.topSpeed,
      required super.horsepower,
      required super.torque,
      required super.weight,
      required super.features});

  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    try {
      return VehicleDetailsModel(
        id: json['_id'] ?? '',
        name: json['vehicle_id']['name'],
        vendorId: json['vendor_id']['_id'],
        dailyPrice: json['daily_rate'],
        twoDayPrice: json['two_day_rate'],
        threeDayPrice: json['three_day_rate'],
        fourDayPrice: json['four_day_rate'],
        fiveDayPrice: json['five_day_rate'],
        sixDayPrice: json['six_day_rate'],
        weeklyPrice: json['weekly_rate'],
        twoWeekPrice: json['two_week_rate'],
        threeWeekPrice: json['three_week_rate'],
        monthlyPrice: json['monthly_rate'],
        twoMonthPrice: json['two_month_rate'],
        threeMonthPrice: json['three_month_rate'],
        deliveryFees: json['delivery_fee'],
        availableDelivery: json['available_delivery'],
        availabilityStatus: json['availability_status'],
        bussinessName: json['vendor_id']['business_name'],
        bussinessAddress: json['vendor_id']['business_address'],
        images: json['images'],
        year: json['vehicle_id']['year'],
        variant: json['vehicle_id']['variant'],
        // pricePerDay: json['pricePerDay'],
        engineCc: json['vehicle_id']['engine_cc'],
        fuelType: json['vehicle_id']['fuel_type'],
        bodyType: json['vehicle_id']['body_type'],
        mileage: json['vehicle_id']['mileage'],
        topSpeed: json['vehicle_id']['top_speed'],
        horsepower: json['vehicle_id']['horsepower'],
        torque: json['vehicle_id']['torque'],
        weight: json['vehicle_id']['weight'],
        features: json['vehicle_id']['features'],
      );
    } catch (e) {
      print("Error parsing vehicle details: $e");
      print("JSON data: $json");
      rethrow;
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor_id': vendorId,
      'name': name,
      'dailyPrice': dailyPrice,
      'availableDelivery': availableDelivery,
      'availabilityStatus': availabilityStatus,
      'bussinessName': bussinessName,
      'bussinessAddress': bussinessAddress,
      'images': images,
      'year': year,
      'variant': variant,
      'engineCc': engineCc,
      'fuelType': fuelType,
      'bodyType': bodyType,
      'mileage': mileage,
      'topSpeed': topSpeed,
      'horsepower': horsepower,
      'torque': torque,
      'weight': weight,
      'features': features,
    };
  }
}
