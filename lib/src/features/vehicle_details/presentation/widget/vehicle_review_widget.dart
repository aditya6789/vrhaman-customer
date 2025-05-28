import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/common/loading.dart';
import 'package:vrhaman/src/core/cubit/review_cubit.dart';
import 'package:vrhaman/src/core/entities/review_data_entity.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/widget/review_card_widget.dart';



class VehicleReviewWidget extends StatelessWidget {
  const VehicleReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
                                builder: (context, state) {
                                  if(state is ReviewError){
                                    return Center(child: Text('No reviews yet', style: smallTextStyle));
                                  }
                                  if (state is ReviewLoading) {
                                    return const Loading();
                                  } else if (state is ReviewsLoaded) {
                                    final reviews = state.reviews;
                                    print('reviews: ${reviews}');
                                    if (reviews.isEmpty) {
                                      return Center(child: Text('No reviews yet', style: smallTextStyle));

                                    }
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              (reviews.fold(0, (sum, review) => sum + review.rating) / reviews.length).toStringAsFixed(1),
                                              style: bigTextStyle.copyWith(fontWeight: FontWeight.bold)
                                            ),
                                            SizedBox(width: 10),
                                            Row(
                                              children: List.generate(5, (index) {
                                                return Icon(
                                                  index < (reviews.fold(0, (sum, review) => sum + review.rating) / reviews.length).round() ? Icons.star : Icons.star_border,
                                                  color: Colors.yellow,
                                                  size: 30,
                                                );
                                              }),
                                            ),
                                          ],




                                        ),
                                        SizedBox(height: 16),
                                        ...reviews.take(2).map<Widget>((review) {
                                          return ReviewCard(review: review);
                                        }).toList(),
                                           SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  _showAllReviews(context, reviews);
                                },
                                child: Text('Show all reviews', style: smallTextStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.blue)),
                              ),
                              SizedBox(height: 16),
                                      ],
                                    );
                                  } else if (state is ReviewError) {
                                    print('state: ${state}');
                                    return Center(child: Text(state.message, style: smallTextStyle));
                                  } else {
                                    return Container();
                                  }
                                },
                              );
  }



  void _showAllReviews(BuildContext context, List<ReviewDataEntity> reviews) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.0 , vertical: 16.0), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reviews & Ratings', style: bigTextStyle),
            SizedBox(height: 16),
            Text('All reviews for this vehicle', style: smallTextStyle.copyWith(color: Colors.grey)),
            SizedBox(height: 16),
            ...reviews.map<Widget>((review) {
              return ReviewCard(review: review);
            }).toList(),
          ],
        )),
       

      ),
    );
  }
}