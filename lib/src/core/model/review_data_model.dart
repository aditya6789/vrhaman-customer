import 'package:vrhaman/src/core/entities/review_data_entity.dart';

class ReviewDataModel extends ReviewDataEntity{
  ReviewDataModel({
    required super.id,
    required super.customerName,
    required super.comment,
    required super.rating,
    required super.createdAt,
  });

  factory ReviewDataModel.fromJson(Map<String, dynamic> json) {
    return ReviewDataModel(
      id: json['_id'],
      customerName: json['userId']['name'],
      comment: json['comment'],
      rating: json['rating'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'comment': comment,
      'rating': rating,
      'created_at': createdAt,
    };
  }
}
