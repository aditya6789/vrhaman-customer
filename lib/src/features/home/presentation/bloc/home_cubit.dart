import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vrhaman/src/features/home/domain/entities/brand.dart';
import 'package:vrhaman/src/features/home/domain/entities/vehicle.dart';
import 'package:vrhaman/src/features/home/domain/usecases/home_usecases.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/home/domain/repositories/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    try {
      print('Fetching home data...');
      final popularBikesEither = await _repository.getPopularBikes();
      final popularCarsEither = await _repository.getPopularCars();
      final userPreferredEither = await _repository.getUserPreferredVehicles();
      final bestDealsEither = await _repository.getBestDeals();
      final brandsEither = await _repository.getBrands();

      popularBikesEither.fold(
        (failure) {
          print('Popular Bikes Failure: ${failure.message}');
          emit(HomeError(failure.message));
        },
        (popularBikes) {
          print('Popular Bikes Success: ${popularBikes.length} items');
          popularCarsEither.fold(
            (failure) => emit(HomeError(failure.message)),
            (popularCars) {
              userPreferredEither.fold(
                (failure) => emit(HomeError(failure.message)),
                (userPreferred) {
                  bestDealsEither.fold(
                    (failure) => emit(HomeError(failure.message)),
                    (bestDeals) {
                      print('Emitting HomeSuccess with data');
                      brandsEither.fold(
                        (failure) => emit(HomeError(failure.message)),
                        (brands) {
                          print('Brands: ${brands.length}');
                          emit(HomeSuccess(
                            popularBikes: popularBikes,
                            popularCars: popularCars,
                            userPreferred: userPreferred,
                            bestDeals: bestDeals,
                            brands: brands,
                          ));
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    } catch (e) {
      print('Cubit Error: $e');
      emit(HomeError(e.toString()));
    }
  }
}
