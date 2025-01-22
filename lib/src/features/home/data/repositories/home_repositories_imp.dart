import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/home/data/datasources/home_data_sources.dart';
import 'package:vrhaman/src/features/home/domain/entities/brand.dart';
import 'package:vrhaman/src/features/home/domain/entities/vehicle.dart';
import 'package:vrhaman/src/features/home/domain/repositories/home_repository.dart';


class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Vehicle>>> getPopularBikes() async {
    try {
      final vehicles = await _remoteDataSource.getPopularBikes();
      return Right(vehicles.map((model) => model.toEntity()).toList());
    } catch (e) {
      print('Repository Popular Bikes Error: $e');
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Vehicle>>> getPopularCars() async {
    try {
      final vehicles = await _remoteDataSource.getPopularCars();
      return Right(vehicles.map((model) => model.toEntity()).toList());
    } catch (e) {
      print('Repository Popular Cars Error: $e');
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Vehicle>>> getUserPreferredVehicles() async {
    try {
      final vehicles = await _remoteDataSource.getUserPreferredVehicles();
      return Right(vehicles.map((model) => model.toEntity()).toList());
    } catch (e) {
      print('Repository User Preferred Error: $e');
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, List<Vehicle>>> getBestDeals() async {
    try {
      final vehicles = await _remoteDataSource.getBestDeals();
      return Right(vehicles.map((model) => model.toEntity()).toList());
    } catch (e) {
      print('Repository Best Deals Error: $e');
      return Left(Failure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<Brand>>> getBrands() async {
    try {
      final brands = await _remoteDataSource.getBrands();
      return Right(brands.map((model) => model.toEntity()).toList());
    } catch (e) {
      print('Repository Brands Error: $e');
      return Left(Failure(e.toString()));
    }
  }
}
