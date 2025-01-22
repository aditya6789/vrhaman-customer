import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingAvailable.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingdata.dart';
import 'package:vrhaman/src/features/booking/domain/usecases/booking_vehicle_usecase.dart';
import 'package:vrhaman/src/utils/api_response.dart';

class BookingCubit extends Cubit<BookingState> {
  final GetAllBookingVehiclesUseCase getAllBookingVehiclesUseCase;

  BookingCubit(this.getAllBookingVehiclesUseCase) : super(BookingInitial());

    TextEditingController _searchController = TextEditingController();
  List<BookingVehicle> _allBookings = [];
  List<BookingVehicle> _filteredBookings = [];

    Future<void> checkAvailability(BookingData bookingData) async {
    emit(BookingLoading());
 try {
      final result = await getAllBookingVehiclesUseCase.checkAvailability(bookingData);

      result.fold(
        (failure) {
      print("booking error ${failure.message}");
      emit(BookingError(failure.message));
    },
    (data) {
      print("booking response $data");
      emit(BookingSuccessAvailable(data));
        },
      );
    } catch (e) {
      print("booking error ${e}");
      emit(BookingError(e.toString()));
    }
  }

    Future<void> postBooking(BookingData bookingData) async {
    emit(BookingLoading());
 try {
      final result = await getAllBookingVehiclesUseCase.postBooking(bookingData);

      result.fold(
        (failure) {
      print("booking error ${failure.message}");
      emit(BookingError(failure.message));
    },
    (data) {
      print("booking response $data");
      emit(BookingSuccess(data));
        },
      );
    } catch (e) {
      print("booking error ${e}");
      emit(BookingError(e.toString()));
    }
  }

 

  Future<void> getBookings() async {
    emit(GetBookingsLoading());
    try {
      final result = await getAllBookingVehiclesUseCase();
      result.fold(
        (failure) {
          print("booking error ${failure.message}");
          emit(GetBookingsError(failure.message));
        },
        (data) {
          print("get booking response $data");
          emit(GetBookingsSuccess(data));
        },
      );
    } catch (e) {
      print("booking error ${e}");
      emit(GetBookingsError(e.toString()));
    }
  }
}

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final dynamic data;
  BookingSuccess(this.data);
}
class BookingSuccessAvailable extends BookingState {
  final BookingAvailable data;
  BookingSuccessAvailable(this.data);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

class GetBookingsLoading extends BookingState {}

class GetBookingsSuccess extends BookingState {
  final dynamic data;
  GetBookingsSuccess(this.data);
}

class GetBookingsError extends BookingState {
  final String message;
  GetBookingsError(this.message);
}


