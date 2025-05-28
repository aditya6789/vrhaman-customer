import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vrhaman/src/core/data/review_data_source.dart';
import 'package:vrhaman/src/core/entities/review_data_entity.dart';
import 'package:vrhaman/src/core/entities/review_entity.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewDataSource reviewDataSource;

  ReviewCubit({required this.reviewDataSource}) : super(ReviewInitial());

  final TextEditingController ratingController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  Future<bool> submitReview(ReviewEntity review) async {
    emit(ReviewLoading());
    try {
      final result = await reviewDataSource.submitReview(review);
      print('review result: ${result}');
      emit(ReviewSuccess(result));
      return true;
    } catch (e) {
      emit(ReviewError(e.toString()));
      return false;
    }
  }

  Future<void> getReviews(String bookingId) async {
    emit(ReviewLoading());
    try {
      final reviews = await reviewDataSource.getReviews(bookingId);
      emit(ReviewsLoaded(reviews));
    } catch (e) {
      print('error: $e');
      emit(ReviewError(e.toString()));
    }
  }
}

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final String message;
  ReviewSuccess(this.message);
}

class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}

class ReviewsLoaded extends ReviewState {
  final List<ReviewDataEntity> reviews;
  ReviewsLoaded(this.reviews);
}

