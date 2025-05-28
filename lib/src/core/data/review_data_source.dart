import 'package:dio/dio.dart';
import 'package:vrhaman/src/core/entities/review_data_entity.dart';
import 'package:vrhaman/src/core/entities/review_entity.dart';
import 'package:vrhaman/src/core/model/review_data_model.dart';
import 'package:vrhaman/src/utils/api_response.dart';

abstract interface class ReviewDataSource {
  Future< String> submitReview(ReviewEntity review);
  Future<List<ReviewDataEntity>> getReviews(String bookingId);
}



class ReviewDataSourceImpl implements ReviewDataSource {
  @override
  Future<String> submitReview(ReviewEntity review) async {
    print('review: $review');
    try {
      final Map<String, dynamic> reviewData = {
        'userId': review.userId,
        'vehicleId': review.vehicleId,
        'rating': review.rating,
        'comment': review.comment,
        'created_at': review.createdAt.toIso8601String(),
      };

      final response = await postRequest('reviews/', reviewData);

      if (response.statusCode == 201) {
        print('response: ${response.data}');
        return 'Review submitted successfully';
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      print('error: $e');
      throw Exception('Failed to submit review: $e');
    }
  }

  @override
  Future<List<ReviewDataEntity>> getReviews(String bookingId) async {
    try {
      final response = await getRequest('reviews/$bookingId');
      print('review response : ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> reviews = response.data['reviews'] as List;
        return reviews.map((json) => ReviewDataModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        print('error: ${response.data['message']}');
        throw Exception(response.data['message']);
      } else {
        print('error: ${response.data['message']}');
        throw Exception(response.data['message']);
      }
    } catch (e) {
      print('error: $e');
      throw Exception('Failed to get reviews: $e');
    }
  }
}
