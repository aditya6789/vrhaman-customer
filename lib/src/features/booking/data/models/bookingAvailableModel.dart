import 'package:vrhaman/src/features/booking/domain/entities/bookingAvailable.dart';

class BookingAvailableModel extends BookingAvailable {
  BookingAvailableModel({required super.message, required super.available});
  factory BookingAvailableModel.fromJson(Map<String, dynamic> json) {
    return BookingAvailableModel(
      message: json['message'],
      available: json['data']['available'],
    );
  }
}
