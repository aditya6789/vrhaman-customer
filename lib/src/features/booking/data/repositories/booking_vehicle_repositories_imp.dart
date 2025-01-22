import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/booking/data/datasocurces/booking_vehicle_datasources.dart';
import 'package:vrhaman/src/features/booking/data/models/bookingDataModel.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingAvailable.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingdata.dart';
import 'package:vrhaman/src/features/booking/domain/entities/confirmBookingData.dart';
import 'package:vrhaman/src/features/booking/domain/repositories/booking_repositories.dart';

class BookingVehicleRepositoriesImpl implements VehicleRepositories {
  final BookingVehicleDataSource dataSource;

  BookingVehicleRepositoriesImpl(this.dataSource);

  @override
  Future<Either<Failure, List<BookingVehicle>>> getAllVehicles() async {
    try {
      final result = await dataSource.getAllBookingVehicle(); // Replace 'some_id' with the actual id
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConfirmBookingData>> postBooking(BookingData bookingData) async {
    try {
      final bookingDataModel = BookingDataModel(
        startDate: bookingData.startDate,
        duration: bookingData.duration,
        startTime: bookingData.startTime,
        customerId: bookingData.customerId,
        vehicleId: bookingData.vehicleId,
        vendorId: bookingData.vendorId,
        paymentType: bookingData.paymentType,
        isDeliveryAtHome: bookingData.isDeliveryAtHome,
      );
      final result = await dataSource.postBooking(bookingDataModel);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingAvailable>> checkAvailability(BookingData bookingData) async {
    final bookingDataModel = BookingDataModel(
      startDate: bookingData.startDate,
      duration: bookingData.duration,
      startTime: bookingData.startTime,
      customerId: bookingData.customerId,
      vehicleId: bookingData.vehicleId,
      paymentType: bookingData.paymentType,
      vendorId: bookingData.vendorId,
      isDeliveryAtHome: bookingData.isDeliveryAtHome,
    );
    final result = await dataSource.checkAvailability(bookingDataModel);
    return Right(result);
  }
}
