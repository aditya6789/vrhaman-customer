import 'package:flutter/material.dart';

import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';

import 'package:vrhaman/src/features/search/domain/entities/searchdata.dart';

import 'package:vrhaman/src/features/search/presentation/widget/information_card_widget.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/pages/vehicle_details_screen.dart';

import 'package:vrhaman/src/features/search/presentation/widget/short_by_bottomSheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchResultScreen extends StatefulWidget {
  final List<SearchData> search;
  final String location;
  final String date;
  final String time;
  final String duration;

  const SearchResultScreen({super.key, required this.search, required this.location, required this.date, required this.time, required this.duration});


  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('search result ${widget.search}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Location',
                                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                              ),
                              Text(
                                widget.location,
                                style: extraSmallTextStyle.copyWith(overflow: TextOverflow.ellipsis),
                                maxLines: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Date', style: extraSmallTextStyle.copyWith(color: Colors.grey)),
                            Text(widget.date, style: extraSmallTextStyle),
                          ],
                        ),
                        Container(
                          height: 50.h,
                          child: VerticalDivider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Time', style: extraSmallTextStyle.copyWith(color: Colors.grey)),
                            Text(widget.time, style: extraSmallTextStyle),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Search Result", style: mediumTextStyle),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => SortByBottomSheet(
                            currentFilter: 'Relevance',
                            onSortOptionSelected: (sortOption) {
                              setState(() {
                                if (sortOption == 'Price - Low to High') {
                                  widget.search.sort((a, b) {
                                    int priceA = widget.duration == 'Days' ? a.dailyPrice : 
                                                widget.duration == 'Weeks' ? a.weeklyPrice : a.monthlyPrice;
                                    int priceB = widget.duration == 'Days' ? b.dailyPrice :
                                                widget.duration == 'Weeks' ? b.weeklyPrice : b.monthlyPrice;
                                    return priceA.compareTo(priceB);
                                  });

                                } else if (sortOption == 'Price - High to Low') {
                                  widget.search.sort((a, b) {
                                    int priceA = widget.duration == 'Days' ? a.dailyPrice :
                                                widget.duration == 'Weeks' ? a.weeklyPrice : a.monthlyPrice;
                                    int priceB = widget.duration == 'Days' ? b.dailyPrice :
                                                widget.duration == 'Weeks' ? b.weeklyPrice : b.monthlyPrice;  

                                                widget.duration == 'Weekly' ? b.weeklyPrice : b.monthlyPrice;
                                    return priceB.compareTo(priceA);
                                  });
                                } else if (sortOption == 'Ratings - High to Low') {
                                  widget.search.sort((a, b) {
                                    return b.averageRating.compareTo(a.averageRating);
                                  });
                                }else if (sortOption == 'Ratings - Low to High') {
                                  widget.search.sort((a, b) {
                                    return a.averageRating.compareTo(b.averageRating);
                                  });
                                }else if (sortOption == 'Distance - Low to High') {
                                  widget.search.sort((a, b) {
                                    return a.distance.compareTo(b.distance);
                                  });
                                }else if (sortOption == 'Distance - High to Low') {
                                  widget.search.sort((a, b) {
                                    return b.distance.compareTo(a.distance);
                                  });
                                }



                              });
                            },


                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(HugeIcons.strokeRoundedFilter),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text("${widget.search.length} results found", style: TextStyle(fontSize: 16.sp, color: Colors.grey),),
                SizedBox(height: 20.h),
                Column(
                  children: widget.search.map((searchData) {
                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => VehicleDetailsScreen()));
                      },
                      child: InformationCardWidget(
                        duration: widget.duration,
                        search: searchData, onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => VehicleDetailsScreen(vehicleId: searchData.id)));
                      }),
                    );

                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// class CarListHeader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
          
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.search),
//                       hintText: 'Search for model, features, etc',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () {},
//                     icon: Icon(Icons.sort),
//                     label: Text('Sort By'),
                   
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: CarListHeader(),
//   ));
// }
