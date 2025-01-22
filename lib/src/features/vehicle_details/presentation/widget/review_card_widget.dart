import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';
class ReviewCard extends StatelessWidget {
  final dynamic review;
  const ReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(review['userImage'] ?? 'https://via.placeholder.com/150'),
          ),
          title: Text(review['userName'] ?? 'Anonymous', style: smallTextStyle.copyWith(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(5, (index) => Icon(
                  Icons.star, 
                  color: index < review['rating'] ? Colors.yellow : Colors.grey, 
                  size: 16
                )),
              ),
              SizedBox(height: 4),
              Text(review['comment'] ?? '', style: extraSmallTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}