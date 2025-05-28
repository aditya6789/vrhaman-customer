import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrhaman/constants.dart';


Future<String> uploadSingleImage({
  required File imageFile,
  required String fileName,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');
    print('imageFile: ${imageFile}');
    print('fileName: ${fileName}');
    print('token: ${token}');

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: DioMediaType('image', 'jpeg'),
      ),
    });

    final dio = Dio();
    final response = await dio.post(
      '${API_URL}image-upload/single',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data['data']['imageUrl'];
    } else {
      print('upload image response: ${response.data}');
      throw Exception(response.data['message'] ?? 'Failed to upload image');
    }
  } catch (e) {
    print('upload image error: ${e.toString()}');
    throw Exception('Error uploading image: ${e.toString()}');
  }
}

Future<List<String>> uploadMultipleImages({
  required List<File> imageFiles,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');

    final formData = FormData();
    
    for (var i = 0; i < imageFiles.length; i++) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(
            imageFiles[i].path,
            filename: 'image_$i.jpg',
            contentType: DioMediaType('image', 'jpeg'),
          ),
        ),
      );
    }

    final dio = Dio();
    final response = await dio.post(
      '${API_URL}image-upload/multiple',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> urls = response.data['data']['imageUrls'];
      return urls.map((url) => url.toString()).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to upload images');
    }
  } catch (e) {
    throw Exception('Error uploading images: ${e.toString()}');
  }
}
