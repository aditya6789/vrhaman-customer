import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';

class VehicleDetailsModel extends VehicleDetails {
  VehicleDetailsModel({
    required super.id,
    required super.name,
    required super.vendorId,
    required super.bussinessName,
    required super.bussinessAddress,
    required super.pickupAddress,
    required super.pickupLatitude,
    required super.pickupLongitude,
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
    required super.cancellationPolicy,
    required super.privacyPolicy,
    required super.engineCc,
    required super.fuelType,
    required super.bodyType,
    required super.mileage,
    required super.topSpeed,
    required super.horsepower,
    required super.torque,
    required super.weight,
    required super.features,
  });

  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    try {
      final vendorVehicle = json['vendorVehicle'];
      final privacyPolicyData = json['privacyPolicy'];
      final vehicleData = vendorVehicle['vehicle_id'];
      final vendorData = vendorVehicle['vendor_id'];
      final pickupLocation = vendorData['pickup_location'] ?? {};

      return VehicleDetailsModel(
        id: vendorVehicle['_id'] ?? '',
        name: vehicleData['name'] ?? '',
        vendorId: vendorData['_id'] ?? '',
        bussinessName: vendorData['business_name'] ?? '',
        bussinessAddress: vendorData['business_address'] ?? '',
        pickupAddress: pickupLocation['address'] ?? '',
        pickupLatitude: (pickupLocation['latitude'] ?? 0.0).toDouble(),
        pickupLongitude: (pickupLocation['longitude'] ?? 0.0).toDouble(),
        dailyPrice: vendorVehicle['daily_rate'] ?? 0,
        twoDayPrice: vendorVehicle['two_day_rate'] ?? 0,
        threeDayPrice: vendorVehicle['three_day_rate'] ?? 0,
        fourDayPrice: vendorVehicle['four_day_rate'] ?? 0,
        fiveDayPrice: vendorVehicle['five_day_rate'] ?? 0,
        sixDayPrice: vendorVehicle['six_day_rate'] ?? 0,
        weeklyPrice: vendorVehicle['weekly_rate'] ?? 0,
        twoWeekPrice: vendorVehicle['two_week_rate'] ?? 0,
        threeWeekPrice: vendorVehicle['three_week_rate'] ?? 0,
        monthlyPrice: vendorVehicle['monthly_rate'] ?? 0,
        twoMonthPrice: vendorVehicle['two_month_rate'] ?? 0,
        threeMonthPrice: vendorVehicle['three_month_rate'] ?? 0,
        deliveryFees: vendorVehicle['delivery_fee'] ?? 0,
        availableDelivery: vendorVehicle['available_delivery'] ?? '',
        availabilityStatus: vendorVehicle['availability_status'] ?? '',
        images: List<String>.from(vendorVehicle['images'] ?? []),
        year: vehicleData['year'] ?? 0,
        variant: vehicleData['variant'] ?? '',
        cancellationPolicy: privacyPolicyData?['cancellation_policy'] ?? '',
        privacyPolicy: privacyPolicyData?['terms_conditions'] ?? '',
        engineCc: vehicleData['engine_cc'] ?? 0,
        fuelType: vehicleData['fuel_type'] ?? '',
        bodyType: vehicleData['body_type'] ?? '',
        mileage: vehicleData['mileage'] ?? 0,
        topSpeed: vehicleData['top_speed'] ?? 0,
        horsepower: vehicleData['horsepower'] ?? 0,
        torque: vehicleData['torque'] ?? 0,
        weight: vehicleData['weight'] ?? 0,
        features: List<String>.from(vehicleData['features'] ?? []),
      );
    } catch (e, stackTrace) {
      print('Error parsing VehicleDetailsModel: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'vendorId': vendorId,
      'bussinessName': bussinessName,
      'bussinessAddress': bussinessAddress,
      'pickupAddress': pickupAddress,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'dailyPrice': dailyPrice,
      'twoDayPrice': twoDayPrice,
      'threeDayPrice': threeDayPrice,
      'fourDayPrice': fourDayPrice,
      'fiveDayPrice': fiveDayPrice,
      'sixDayPrice': sixDayPrice,
      'weeklyPrice': weeklyPrice,
      'twoWeekPrice': twoWeekPrice,
      'threeWeekPrice': threeWeekPrice,
      'monthlyPrice': monthlyPrice,
      'twoMonthPrice': twoMonthPrice,
      'threeMonthPrice': threeMonthPrice,
      'deliveryFees': deliveryFees,
      'availableDelivery': availableDelivery,
      'availabilityStatus': availabilityStatus,
      'images': images,
      'year': year,
      'variant': variant,
      'cancellationPolicy': cancellationPolicy,
      'privacyPolicy': privacyPolicy,
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
