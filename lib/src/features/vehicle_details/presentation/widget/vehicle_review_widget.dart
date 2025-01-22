import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/common/loading.dart';
import 'package:vrhaman/src/features/review/review_cubit/review_cubit.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/widget/review_card_widget.dart';

class VehicleReviewWidget extends StatelessWidget {
  const VehicleReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
                                builder: (context, state) {
                                  if(state is ReviewEmpty){
                                    return Center(child: Text(state.message, style: smallTextStyle));
                                  }
                                  if (state is ReviewLoading) {
                                    return const Loading();
                                  } else if (state is ReviewLoaded) {
                                    final reviews = state.reviews;
                                    if (reviews.isEmpty) {
                                      return Center(child: Text('No reviews yet', style: smallTextStyle));
                                    }
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text('5.0', style: bigTextStyle.copyWith(fontWeight: FontWeight.bold)),
                                            SizedBox(width: 10),
                                            Row(
                                              children: List.generate(5, (index) => Icon(Icons.star, color: Colors.yellow, size: 30)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        ...reviews.map<Widget>((review) {
                                          return ReviewCard(review: review);
                                        }).toList(),
                                           SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {},
                                child: Text('Show all reviews', style: smallTextStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.blue)),
                              ),
                              SizedBox(height: 16),
                                      ],
                                    );
                                  } else if (state is ReviewError) {
                                    print('state: ${state}');
                                    return Center(child: Text(state.error, style: smallTextStyle));
                                  } else {
                                    return Container();
                                  }
                                },
                              );
  }
}