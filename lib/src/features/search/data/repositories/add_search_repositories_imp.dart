import 'package:fpdart/fpdart.dart';
import 'package:vrhaman/src/core/error/failure.dart';
import 'package:vrhaman/src/core/model/common_vehicle_model.dart';
import 'package:vrhaman/src/features/search/data/data_sources/search_data_sources.dart';
import 'package:vrhaman/src/features/search/data/model/addSearchModel.dart';
import 'package:vrhaman/src/features/search/data/model/searchDataModel.dart';
import 'package:vrhaman/src/features/search/domain/entities/addSearch.dart';
import 'package:vrhaman/src/features/search/domain/entities/searchdata.dart';
import 'package:vrhaman/src/features/search/domain/repositories/search_repositories.dart';


class AddSearchRepositoryImpl implements SearchRepository {
  final SearchDataSource searchDataSource;

  AddSearchRepositoryImpl({required this.searchDataSource});

  @override
  Future<Either<Failure, List<SearchData>>> addSearch(AddSearch addSearch) async {
    try {
      final addSearchModel = AddSearchModel(
        startDate: addSearch.startDate,
        duration: addSearch.duration,
        vehicleType: addSearch.vehicleType,
        location: addSearch.location,
      );
      
      // Call the data source and handle the response
      final searchDataModelList = await searchDataSource.addSearch(addSearchModel);
      final searchDataModel = searchDataModelList;
      
      // You can use commonVehicleModel here if needed
      // For example, you might want to map it back to an AddSearch entity

      return Right(searchDataModel); // Return the first item
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
