part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Vehicle> popularBikes;
  final List<Vehicle> popularCars;
  final List<Vehicle> userPreferred;
  final List<Vehicle> bestDeals;
  final List<Brand> brands;

  const HomeSuccess({
    required this.popularBikes,
    required this.popularCars,
    required this.userPreferred,
    required this.bestDeals,
    required this.brands,
  });

  @override
  List<Object> get props => [popularBikes, popularCars, userPreferred, bestDeals, brands];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
