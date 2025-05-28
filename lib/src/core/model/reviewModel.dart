import 'package:vrhaman/src/core/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel(
      {required super.userId,
      required super.vehicleId,
      required super.rating,
      required super.comment,
      required super.createdAt,
     });

      factory ReviewModel.fromJson(Map<String, dynamic> json) {
        return ReviewModel(
          userId: json['userId'],
          vehicleId: json['vehicleId'],
          rating: json['rating'],
          comment: json['comment'],
          createdAt: json['createdAt'],
          
        );
      }
      


}
