import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/features/home/domain/entities/vehicle.dart';
import 'package:vrhaman/src/features/home/domain/entities/brand.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Vehicle>>> getPopularBikes();
  Future<Either<Failure, List<Vehicle>>> getPopularCars();
  Future<Either<Failure, List<Vehicle>>> getUserPreferredVehicles();
  Future<Either<Failure, List<Vehicle>>> getBestDeals();
  Future<Either<Failure, List<Brand>>> getBrands();
} 