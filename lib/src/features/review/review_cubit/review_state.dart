part of 'review_cubit.dart';

@immutable
abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final String message;
  ReviewSuccess(this.message);
}

class ReviewLoaded extends ReviewState {
  final List<dynamic> reviews;
  ReviewLoaded(this.reviews);
}

class ReviewError extends ReviewState {
  final String error;
  ReviewError(this.error);
}

class ReviewEmpty extends ReviewState {
  final String message;
  ReviewEmpty(this.message);
}
