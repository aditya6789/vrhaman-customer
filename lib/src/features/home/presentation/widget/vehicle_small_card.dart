import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/pages/vehicle_details_screen.dart';
import 'package:vrhaman/src/features/wishlist/domain/entities/addWishlist.dart';
import 'package:vrhaman/src/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class VehicleSmallCard extends StatefulWidget {
  final String vehicleId;
  final String image;
  final String name;
  final String price;
  final String description;

  const VehicleSmallCard({
    Key? key,
    required this.vehicleId,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
  }) : super(key: key);

  @override
  State<VehicleSmallCard> createState() => _VehicleSmallCardState();
}

class _VehicleSmallCardState extends State<VehicleSmallCard> with SingleTickerProviderStateMixin {
  bool isInWishlist = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleDetailsScreen(vehicleId: widget.vehicleId),
          ),
        );
      },
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Gradient Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                      stops: [0.6, 1.0],
                    ).createShader(bounds),
                    blendMode: BlendMode.darken,
                    child: Image.network(
                      widget.image,
                      height: 150.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180.h,
                          color: Colors.grey[200],
                          child: Icon(Icons.error_outline, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                // Favorite Button with Glassmorphism
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isInWishlist = !isInWishlist;
                      });
                      _controller.forward().then((_) {
                        _controller.reverse();
                      });
                      context.read<WishlistCubit>().addWishlist(AddWishlist(vehicleId: widget.vehicleId));
                    },
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    isInWishlist ? Icons.favorite : Icons.favorite_border,
                                    size: 20.sp,
                                    color: isInWishlist ? Colors.red : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Status Badge
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Available',
                          style: smallTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.name,
                          style: mediumTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.green,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '5.00',
                              style: smallTextStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),


                  // Vehicle Specs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSpecItem(Icons.person_outline, '4 Seats'),
                      _buildSpecItem(Icons.local_gas_station_outlined, 'Petrol'),
                      _buildSpecItem(Icons.speed_outlined, 'Auto'),
                     
                    ],
                  ),
                  SizedBox(height: 9.h,),
                   Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '\$${widget.price}/h',
                          style: extraSmallTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: primaryColor,
          ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: extraSmallTextStyle.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
