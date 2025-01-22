import 'dart:convert';

import 'package:vrhaman/src/core/error/exceptions.dart';
import 'package:vrhaman/src/features/booking/data/models/bookingAvailableModel.dart';
import 'package:vrhaman/src/features/booking/data/models/bookingDataModel.dart';
import 'package:vrhaman/src/features/booking/data/models/bookingVehicleModel.dart';
import 'package:vrhaman/src/features/booking/data/models/confirmBookingDataModel.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';
import 'package:vrhaman/src/features/booking/domain/entities/confirmBookingData.dart';
import 'package:vrhaman/src/utils/api_response.dart';

abstract class BookingVehicleDataSource {
  Future<List<BookingVehicle>> getAllBookingVehicle();
  Future<ConfirmBookingData> postBooking(BookingDataModel bookingDataModel);
  Future<BookingAvailableModel> checkAvailability(BookingDataModel bookingDataModel);
}

class BookingVehicleDataSourceImpl implements BookingVehicleDataSource {
  @override
  Future<List<BookingVehicle>> getAllBookingVehicle() async {
    try {
      final response = await getRequest('booking');
      print("get booking vehicle response ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> resData = response.data['data']['bookings'] as List;
        return resData.map((booking) {
          final bookingMap = booking as Map<String, dynamic>;
          return BookingVehicleModel.fromJson(bookingMap);
        }).toList();
      } else {
        throw ServerException('Failed to load booking vehicle');
      }
    } catch (e) {
      print("get booking vehicle error ${e.toString()}");
      throw ServerException(e.toString());
    }
  }
  @override
  Future<ConfirmBookingData> postBooking(BookingDataModel bookingDataModel) async {
    try {
      final response = await postRequest('booking/', {
        'start_date': bookingDataModel.startDate,
        'duration': bookingDataModel.duration,
        'start_time': bookingDataModel.startTime,
        'customer_id': bookingDataModel.customerId,
        'vehicle_id': bookingDataModel.vehicleId,
        'vendor_id': bookingDataModel.vendorId,
        'payment_type':bookingDataModel.paymentType,
        'delivery': bookingDataModel.isDeliveryAtHome,
      });
      print('booking response ${response.data}');

      if (response.statusCode == 201) {
        if (response.data != null && 
            response.data['data'] != null && 
            response.data['data']['booking'] != null) {
          // The booking data is already a Map, no need to decode
          print("response.data: ${response.data}");
          final resData = response.data['data']['booking'] as Map<String, dynamic>;
          print("resData: $resData");
          return ConfirmBookingDataModel.fromJson(resData);
        } else {
          throw ServerException('Invalid response format: Missing booking data');
        }
      } else {
        final errorMessage = response.data?['message'] as String? ?? 'Failed to create booking';
        throw ServerException(errorMessage);
      }
    } catch (e) {
      print("post booking error: ${e.toString()}");
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to create booking: ${e.toString()}');
    }
  }
  @override
  Future<BookingAvailableModel> checkAvailability(BookingDataModel bookingDataModel) async {
    print("post booking data ${bookingDataModel}");
    try {
      final response = await postRequest('booking/check-availability', {
        'start_date': bookingDataModel.startDate,
        'duration': bookingDataModel.duration,
        'vehicle_id': bookingDataModel.vehicleId,
      });
      // print("post booking response ${response.data}");
      if (response.statusCode == 200) {
        print("post booking response ${response.data}");
        return BookingAvailableModel.fromJson(response.data);
      } else {
        print("post booking error 2 ${response.data}");
        throw ServerException('Failed to load booking vehicle');
      }
    } catch (e) {
      print("post booking error ${e.toString()}");
      throw ServerException(e.toString());
    }
  }

}
