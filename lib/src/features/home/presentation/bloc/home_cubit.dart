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

  Future<void> fetchHomeData(String latitude, String longitude) async {
    emit(HomeLoading());
    try {
      print('Fetching home data...');
      
      // Fetch all data in parallel
      final popularBikesEither = await _repository.getPopularBikes();
      final popularCarsEither = await _repository.getPopularCars();
      final userPreferredEither = await _repository.getUserPreferredVehicles(latitude, longitude);
      final bestDealsEither = await _repository.getBestDeals();
      final brandsEither = await _repository.getBrands();

      // Extract data, using empty lists as fallback
      final popularBikes = popularBikesEither.getRight().toNullable() ?? [];
      final popularCars = popularCarsEither.getRight().toNullable() ?? [];
      final userPreferred = userPreferredEither.getRight().toNullable() ?? [];
      final bestDeals = bestDealsEither.getRight().toNullable() ?? [];
      final brands = brandsEither.getRight().toNullable() ?? [];
      print('User Preferred: ${userPreferred.length}');

      // Emit success with all data, even if some lists are empty
      emit(HomeSuccess(
        popularBikes: popularBikes,
        popularCars: popularCars,
        userPreferred: userPreferred,
        bestDeals: bestDeals,
        brands: brands,
      ));
      
    } catch (e) {
      print('Cubit Error: $e');
      // Emit success with empty lists instead of error to prevent UI crashes
      emit(HomeSuccess(
        popularBikes: [],
        popularCars: [],
        userPreferred: [],
        bestDeals: [],
        brands: [],
      ));
    }
  }
}
