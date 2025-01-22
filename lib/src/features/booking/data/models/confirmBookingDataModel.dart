import 'package:vrhaman/src/features/booking/domain/entities/confirmBookingData.dart';

class ConfirmBookingDataModel extends ConfirmBookingData {
  ConfirmBookingDataModel({
    required super.id,
    required super.customerName,
    required super.customerPhone,
    required super.customerEmail,
    required super.vehicleName,
    required super.vehicleImages,
    required super.isDeliveryAtHome,
    required super.startDate,
    required super.startTime,
    required super.endDate,
    required super.duration,
    required super.totalPrice,
    required super.vendorBusinessName,
    // required super.vendorBusinessEmail,
    required super.vendorBusinessAddress,
  });

  factory ConfirmBookingDataModel.fromJson(Map<String, dynamic> json) {
    return ConfirmBookingDataModel(
      id: json['_id'],
      customerName: json['customer_id']['name'],
      customerPhone: json['customer_id']['phone'],
      customerEmail: json['customer_id']['email'],
      vehicleName: json['vehicle_id']['vehicle_id']['name'],
      vehicleImages: json['vehicle_id']['images'] as List<dynamic>,
      isDeliveryAtHome: json['delivery'],
      startDate: DateTime.parse(json['start_date']),
      startTime: json['start_time'],
      endDate: DateTime.parse(json['end_date']),
      duration: json['duration'],
      totalPrice: json['total_price'],
      vendorBusinessName: json['vendor_id']['business_name'],
      // vendorBusinessEmail: json['vendor_id']['vendor_business_email'],
      vendorBusinessAddress: json['vendor_id']['business_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_email': customerEmail,
      'vehicle_name': vehicleName,
      'vehicle_images': vehicleImages,
      'is_delivery_at_home': isDeliveryAtHome,
      'start_date': startDate,
      'start_time': startTime,
      'end_date': endDate,
      'duration': duration,
      'total_price': totalPrice,
      'vendor_business_name': vendorBusinessName,
      // 'vendor_business_email': vendorBusinessEmail,
      'vendor_business_address': vendorBusinessAddress,
    };
  }
}
