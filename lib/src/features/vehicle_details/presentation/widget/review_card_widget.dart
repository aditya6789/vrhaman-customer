import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/core/entities/review_data_entity.dart';

class ReviewCard extends StatelessWidget {
  final ReviewDataEntity review;
  const ReviewCard({
    super.key, 
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                
           
                
                      Text(
                        review.customerName ?? 'Anonymous',
                        style: smallTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                           SizedBox(width: 16),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star_rounded,
                            color: index < review.rating 
                              ? Color(0xFFFFD700)
                              : Colors.grey.withOpacity(0.3),
                            size: 20,
                          ),
                        ),
                      ),
                   
              
              ],
            ),
            if (review.comment?.isNotEmpty ?? false) ...[
              SizedBox(height: 12),
              Container(
                // padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  review.comment ?? '',
                  style: extraSmallTextStyle.copyWith(
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}