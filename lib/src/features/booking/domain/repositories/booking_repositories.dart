import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingAvailable.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingdata.dart';
import 'package:vrhaman/src/features/booking/domain/entities/confirmBookingData.dart';


abstract interface class VehicleRepositories {
  Future<Either<Failure, List<BookingVehicle>>> getAllVehicles();
  Future<Either<Failure, BookingVehicle>> getBookingVehicleById(String id);
  Future<Either<Failure, ConfirmBookingData>> postBooking(BookingData bookingData);
  Future<Either<Failure, BookingAvailable>> checkAvailability(BookingData bookingData);

}
