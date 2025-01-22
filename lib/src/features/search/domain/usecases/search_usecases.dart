import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/core/model/common_vehicle.dart';
import 'package:vrhaman/src/features/search/domain/entities/addSearch.dart';
import 'package:vrhaman/src/features/search/domain/entities/searchdata.dart';
import 'package:vrhaman/src/features/search/domain/repositories/search_repositories.dart';

class AddSearchUseCase {
  final SearchRepository repository;

  AddSearchUseCase(this.repository);

  Future<Either<Failure, List<SearchData>>> call(AddSearch addSearch) async {
    final result = await repository.addSearch(addSearch);
    return result.map((model) => model as List<SearchData>);
  }
}
