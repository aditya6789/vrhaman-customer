part of 'vehicle_details_cubit.dart';

abstract class VehicleDetailsState extends Equatable {
  const VehicleDetailsState();

  @override
  List<Object> get props => [];
}

class VehicleDetailsInitial extends VehicleDetailsState {}

class VehicleDetailsLoading extends VehicleDetailsState {}

class VehicleDetailsLoaded extends VehicleDetailsState {
  final VehicleDetails vehicleDetails;

  const VehicleDetailsLoaded(this.vehicleDetails);

  @override
  List<Object> get props => [vehicleDetails];
}

class VehicleDetailsError extends VehicleDetailsState {
  final String message;

  const VehicleDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
