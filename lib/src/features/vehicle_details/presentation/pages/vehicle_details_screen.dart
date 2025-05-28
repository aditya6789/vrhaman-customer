import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/common/loading.dart';
import 'package:vrhaman/src/core/cubit/review_cubit.dart';
import 'package:vrhaman/src/features/booking/presentation/screens/booking_screen.dart';
import 'package:vrhaman/src/features/booking/presentation/screens/booking_success_screen.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/bloc/vehicle_details_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/widget/feature_widget_list.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/widget/show_complete.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/widget/vehicle_detail_images.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/widget/vehicle_detail_info.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/widget/vehicle_location_widget.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/widget/vehicle_review_widget.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/widget/vehicle_specification_widget.dart';
import 'package:vrhaman/src/features/wishlist/domain/entities/addWishlist.dart';
import 'package:vrhaman/src/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:vrhaman/src/utils/api_response.dart';
import 'package:vrhaman/src/utils/user_prefences.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final String vehicleId;
  const VehicleDetailsScreen({super.key, required this.vehicleId});
  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  bool isInWishlist = false;
  late AnimationController _controller;
  

  @override
  void initState() {
    super.initState();
    checkdocumentRequest();
    BlocProvider.of<VehicleDetailsCubit>(context)
        .fetchVehicleDetails(widget.vehicleId);
    BlocProvider.of<ReviewCubit>(context).getReviews(widget.vehicleId);
  }

  Future<void> checkdocumentRequest() async {
    try {
      final response = await getRequest('document');
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      }
    } catch (e) {}
  }

  Future<void> checkUserProfile(VehicleDetails vehicleModel) async {
    final user = UserPreferences();
    final userData = await user.getUserData();
    print('userData: ${userData}');

    if (mounted && 
        userData != null &&
        userData['_id'] != null && 
        userData['_id'].toString().isNotEmpty &&
        userData['name'] != null &&
        userData['name'].toString().isNotEmpty &&
        userData['phone'] != null &&
        userData['phone'].toString().isNotEmpty &&
        userData['email'] != null &&
        userData['email'].toString().isNotEmpty &&
        userData['gender'] != null &&
        userData['gender'].toString().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingScreen(
            vehicleId: widget.vehicleId,
            vehicleDetails: vehicleModel,
          )
        )
      );
    } else {
      completeProfile(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<VehicleDetailsCubit, VehicleDetailsState>(
        builder: (context, state) {
          if (state is VehicleDetailsLoading) {
            return const Loading();
          } else if (state is VehicleDetailsLoaded) {
            final vehicleModel = state.vehicleDetails;

            return Stack(
              children: [
                // Custom ScrollView for better scrolling experience
                CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      expandedHeight: 60.h,
                      floating: true,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back, color: Colors.black87, size: 20.sp),
                        ),
                      ),
                      title: Text(
                        'Vehicle Details',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                        isInWishlist = !isInWishlist;
                      });
                      _controller.forward().then((_) {
                        _controller.reverse();
                      });
                      context.read<WishlistCubit>().addWishlist(AddWishlist(vehicleId: widget.vehicleId));

                          },
                          icon: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: isInWishlist ? Colors.red : Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(isInWishlist ? Icons.favorite : Icons.favorite_border_rounded, color: isInWishlist ? Colors.white : Colors.black87, size: 20.sp),
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                    ),

                    // Content
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 100.h),
                    child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                            // Vehicle Images
                        VehicleDetailImages(vehicleModel: vehicleModel),
                            
                            // Vehicle Info
                            Container(
                              margin: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: VehicleDetailInfo(vehicleModel: vehicleModel),
                            ),

                            // Specifications
                        Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: VehicleSpecificationWidget(vehicleModel: vehicleModel),
                            ),

                            SizedBox(height: 16.h),

                            // Features
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.w),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                  Text(
                                    'Features',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                              SizedBox(height: 16.h),
                                  FeatureWidgetList(vehicleModel: vehicleModel),
                                ],
                              ),
                            ),

                              SizedBox(height: 16.h),

                            // Location
                           
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: VehicleLocationWidget(
                                    pickupLocation: vehicleModel.pickupAddress,
                                  ),
                                ),
                            
                              SizedBox(height: 16.h),

                            // Reviews
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.w),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reviews & Ratings',
                                    style: TextStyle(
                                                                            fontSize: 18.sp,

                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                      letterSpacing: -0.5,
                                    ),
                              ),
                              SizedBox(height: 16.h),
                                  const VehicleReviewWidget(),
                                ],
                              ),
                            ),

                              SizedBox(height: 16.h),

                            // Policies
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.w),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Policies',
                                    style: TextStyle(
                                                                          fontSize: 18.sp,

                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                      letterSpacing: -0.5,
                                    ),
                              ),
                              SizedBox(height: 16.h),
                                  _buildPolicyItem(
                                    'Cancellation Policy',
                                   
                                    vehicleModel.cancellationPolicy,
                                    'Cancellation Policy',
                                    Icons.cancel_outlined,
                                    Colors.red,
                                  ),
                              SizedBox(height: 16.h),
                                  _buildPolicyItem(
                                    'Rules & Restrictions',
                                    vehicleModel.privacyPolicy.split(',').join(',\n'),
                                    // vehicleModel.privacyPolicy,
                                    'Rules & Restrictions',
                                    Icons.rule_folder_outlined,
                                    Colors.blue,
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                  ],
                ),

                // Bottom Book Now Button
                if(vehicleModel.availabilityStatus == 'Available')
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                    color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => checkUserProfile(vehicleModel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is VehicleDetailsError) {
            return Center(
              child: Text(
                'Failed to load vehicle details',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildPolicyItem(
    String title,
    String subtitle,
    String description,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
