import 'package:vrhaman/src/core/error/exceptions.dart';
import 'package:vrhaman/src/core/model/common_vehicle_model.dart';
import 'package:vrhaman/src/features/search/data/model/addSearchModel.dart';
import 'package:vrhaman/src/features/search/data/model/searchDataModel.dart';
import 'package:vrhaman/src/utils/api_response.dart';

abstract interface class SearchDataSource {
  Future<List<SearchDataModel>> addSearch(AddSearchModel addSearch);
}

class SearchDataSourceImpl implements SearchDataSource {
  @override
  Future<List<SearchDataModel>> addSearch(AddSearchModel addSearch) async {
    print("Add Search Data Source");
    print(addSearch);
    final location = '{"latitude": ${addSearch.location.latitude}, "longitude": ${addSearch.location.longitude}}';
    print(location);
   try {
    final response = await postRequest(
      'search',
      {
        'startDate': addSearch.startDate,
        'duration': addSearch.duration,
        'vehicleType': addSearch.vehicleType,
        'location': location,
      },
    );
    print(response);
    if (response.statusCode == 200) {
      final List<dynamic> vehiclesJson = response.data['data']['vehicles'];
      print("success ${vehiclesJson}");
      return vehiclesJson.map((json) => SearchDataModel.fromJson(json)).toList();
    } else {
      throw ServerException(response.data['message']);
    }
   } catch (e) {
    print("data source error $e");
    throw e;
   }
  }
}
