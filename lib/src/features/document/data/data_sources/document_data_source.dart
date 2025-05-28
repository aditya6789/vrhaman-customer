import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/core/error/exceptions.dart';
import 'package:vrhaman/src/features/document/data/models/documentDataModel.dart';
import 'package:vrhaman/src/features/document/domain/entities/documentData.dart';
import 'package:vrhaman/src/utils/api_response.dart';
import 'package:vrhaman/src/utils/upload_image.dart';

abstract interface class DocumentDataSource {
  Future<DocumentDataModel> uploadDocument(DocumentData documentData);
  Future<DocumentDataModel> updateDocument(DocumentData documentData);
}

class DocumentDataSourceImpl implements DocumentDataSource {

  final Dio dio = Dio();
  @override
  Future<DocumentDataModel> uploadDocument(DocumentData documentData) async {
    print('documentData: ${documentData.image.path}');

    try {
      final imageResponse = await uploadSingleImage(imageFile: documentData.image, fileName: 'document.jpg');
      print('imageResponse: ${imageResponse}');
      final response = await postRequest('users/upload-document', {
        'document': imageResponse,
      });
      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('document', response.data['data']['document']);
        print(response.data);
        return DocumentDataModel.fromJson(response.data['data']);
      // Store document in shared preferences
    
      } else {
        print('document response error: ${response.data}');
        throw ServerException('Failed to upload document');
      }
      
    } catch (e) {
      print('document data source error: $e');
      throw ServerException('Failed to upload document: $e');
      
    }
  }

  @override
  Future<DocumentDataModel> updateDocument(DocumentData documentData) async {
   final imageResponse = await uploadSingleImage(imageFile: documentData.image, fileName: 'document.jpg');
   final response = await patchRequest('document', {
    'document': imageResponse,
   });
   if (response.statusCode == 200) {
    return DocumentDataModel.fromJson(response.data['data']);
   }
   else {
    print('document response error: ${response.data}');
    throw ServerException('Failed to update document');
   }
  }
}
