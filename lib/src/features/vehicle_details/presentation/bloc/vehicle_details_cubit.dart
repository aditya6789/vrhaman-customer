
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:vrhaman/src/features/vehicle_details/domain/usecase/vehicle_details_usecases.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';


part 'vehicle_details_state.dart';

class VehicleDetailsCubit extends Cubit<VehicleDetailsState> {
  final VehicleDetailsUsecase getVehicleDetailsUseCase;

  VehicleDetailsCubit({required this.getVehicleDetailsUseCase}) : super(VehicleDetailsInitial());

  Future<void> fetchVehicleDetails(String vehicleId) async {
    emit(VehicleDetailsLoading());
    final failureOrVehicleDetails = await getVehicleDetailsUseCase(vehicleId);
    failureOrVehicleDetails.fold(
      (failure) => emit(VehicleDetailsError(failure.message)),
      (vehicleDetails) => emit(VehicleDetailsLoaded(vehicleDetails)),
    );
  }

  // String _mapFailureToMessage(Failure failure) {
  //   // Customize error messages based on the type of failure
  //   switch (failure.runtimeType) {
  //     case ServerFailure:
  //       return 'Server Failure';
  //     case CacheFailure:
  //       return 'Cache Failure';
  //     default:
  //       return 'Unexpected Error';
  //   }
  // }
}
