import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/core/model/common_vehicle_model.dart';
import 'package:vrhaman/src/features/search/domain/entities/addSearch.dart';
import 'package:vrhaman/src/features/search/domain/entities/searchdata.dart';

abstract interface class SearchRepository {
  Future<Either<Failure, List<SearchData>>> addSearch(AddSearch addSearch);
}
