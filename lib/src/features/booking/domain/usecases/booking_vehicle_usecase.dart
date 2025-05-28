import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingAvailable.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingdata.dart';
import 'package:vrhaman/src/features/booking/domain/entities/confirmBookingData.dart';
import 'package:vrhaman/src/features/booking/domain/repositories/booking_repositories.dart';

class GetAllBookingVehiclesUseCase {
  final VehicleRepositories repository;

  GetAllBookingVehiclesUseCase(this.repository);

  Future<Either<Failure, List<BookingVehicle>>> call() async {
    return await repository.getAllVehicles();
  }

  Future<Either<Failure, ConfirmBookingData>> postBooking(BookingData bookingData) async {
    return await repository.postBooking(bookingData);
  }

  Future<Either<Failure, BookingAvailable>> checkAvailability(BookingData bookingData) async {
    return await repository.checkAvailability(bookingData);
  }
  Future<Either<Failure, BookingVehicle>> getBookingVehicleById(String id) async {
    return await repository.getBookingVehicleById(id);
  }
}

