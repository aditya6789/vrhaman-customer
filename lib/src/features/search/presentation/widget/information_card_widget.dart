import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/search/domain/entities/searchdata.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationCardWidget extends StatelessWidget {
  final SearchData search;
  final VoidCallback onTap;
  final String duration;
  const InformationCardWidget({
    super.key,
    required this.search,
    required this.onTap,
    required this.duration,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              clipBehavior: Clip.none,
              children: [
                Hero(
                  tag: 'vehicle_${search.id}',
                  child: Container(
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                      image: DecorationImage(
                        image: NetworkImage(
                          search.vehicleImage.isNotEmpty
                              ? search.vehicleImage[0]
                              : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtc3-y63KN_r5LwOC9PNqpwc5C1JPeN36_ug&s',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.red[400],
                      size: 20.sp,
                    ),
                  ),
                ),
                // Tags
                Positioned(
                  left: 16.w,
                  bottom: -20.h,
                  child: Row(
                    children: [
                      _buildTag(
                        icon: HugeIcons.strokeRoundedCar02,
                        label: "Door Step",
                        color: Colors.green,
                      ),
                      SizedBox(width: 8.w),
                      _buildTag(
                        icon: HugeIcons.strokeRoundedNavigation04,
                        label: search.distance.toString() ,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Content Section
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              search.vehicleName,
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                        
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellow[50],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.orange,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              search.averageRating.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Row(
                  //   children: [
                  //     _buildTag(
                  //       icon: HugeIcons.strokeRoundedEnergy,
                  //       label: '${search.vehicleName} CC',
                  //       color: Colors.blue,
                  //     ),
                  //     SizedBox(width: 8.w),
                  //     _buildTag(
                  //       icon: HugeIcons.strokeRoundedGasStove, 
                  //       label: search.vehicleType,
                  //       color: Colors.green,
                  //     ),
                  //     SizedBox(width: 8.w),
                  //     _buildTag(
                  //       icon: HugeIcons.strokeRoundedUserGroup,
                  //       label: '${search.vehicleName} Seater',
                  //       color: Colors.orange,
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${duration == 'Day' ? search.dailyPrice : duration == 'Week' ? search.weeklyPrice : search.monthlyPrice}/${duration == 'Day' ? 'day' : duration == 'Week' ? 'week' : 'month'}',
                            style: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),

                          Text(
                            '₹${duration == 'Days' ? search.dailyPrice : duration == 'Weeks' ? search.weeklyPrice : search.monthlyPrice}/day',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: Colors.grey[400],
                              decoration: TextDecoration.lineThrough,
                            ),

                          ),
                        
                        ],
                      ),
                   
                     
                    ],
                  ),
                ],
              ),
            ),
              Padding(
                padding: EdgeInsets.only(left: 16.w , bottom: 5.h),
                child: Wrap(
                              spacing: 4.w, 
                              runSpacing: 4.h,
                             
                              children: [
                                Icon(HugeIcons.strokeRoundedHelpCircle, size: 16.sp,),
                                Text('Prices are different according to the duration of booking')
                              ],
                            ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildTag({
    required IconData icon,
    required String label,
    required MaterialColor color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16.sp),
          SizedBox(width: 6.w),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: color[700],
            ),
          ),
        ],
      ),
    );
  }
}
