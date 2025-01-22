import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:vrhaman/src/utils/api_response.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {


  ReviewCubit() : super(ReviewInitial());



  // Create a review
  Future<void> createReview({
    required String vehicleId,
    required int rating,
    required String comment,
  }) async {
    emit(ReviewLoading());
    try {
      final response = await postRequest('/reviews', {
        'vehicleId': vehicleId,
        'rating': rating,
        'comment': comment,
      });
      emit(ReviewSuccess(response.data['message']));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
  // Get all reviews for a vehicle
  Future<void> getVehicleReviews(String vehicleId) async {
    emit(ReviewLoading());
    
    try {
      final response = await getRequest('reviews/${vehicleId}');
      print('review response: ${response.data}');

      if (response.statusCode == 200) {
        emit(ReviewLoaded(response.data['reviews']));
      } else if (response.statusCode == 400) {
        emit(ReviewEmpty('No reviews found'));
      }
    } catch (e) {
      emit(ReviewError('No reviews found'));
    }
  }
}
