import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/core/error/exceptions.dart';
import 'package:vrhaman/src/features/document/data/models/documentDataModel.dart';
import 'package:vrhaman/src/utils/api_response.dart';

abstract interface class DocumentDataSource {
  Future<DocumentDataModel> uploadDocument(DocumentDataModel documentData);
}

class DocumentDataSourceImpl implements DocumentDataSource {

  final Dio dio = Dio();
  @override
  Future<DocumentDataModel> uploadDocument(DocumentDataModel documentData) async {
    print(documentData.image.path);
    try {
      final formData = FormData.fromMap({
        'document': await MultipartFile.fromFile(
          documentData.image.path,
          contentType: DioMediaType('image', 'jpeg'),
        ),
      });
        final String token = await getToken();
  final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

      final response = await dio.post(
        '${API_URL}users/upload-document',
        data: formData,
        options: Options(
          headers: defaultHeaders,
        ),
      );
      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('document', response.data['data']['document']);
        print(response.data);
        return DocumentDataModel.fromJson(response.data['data']);
      // Store document in shared preferences
    
      } else {
        throw ServerException('Failed to upload document');
      }
      
    } catch (e) {
      throw ServerException('Failed to upload document: $e');
      
    }
  }
}
