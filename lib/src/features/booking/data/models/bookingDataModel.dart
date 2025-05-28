import 'package:vrhaman/src/features/booking/domain/entities/bookingdata.dart';

class BookingDataModel extends BookingData {
  BookingDataModel({
    required super.startDate,
    required super.duration,
    required super.startTime,
    required super.customerId,
    required super.vehicleId,
    required super.vendorId,
    required super.isDeliveryAtHome,
    required super.paymentType,
    required super.addressId,
  });
}
