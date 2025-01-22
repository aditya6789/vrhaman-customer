import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/pages/vehicle_details_screen.dart';
import 'package:vrhaman/src/features/wishlist/data/model/wishlistModel.dart';
import 'package:vrhaman/src/features/wishlist/domain/entities/wishlist.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistCardWidget extends StatefulWidget {
  final Wishlist vehicle;
  const WishlistCardWidget({super.key, required this.vehicle});

  @override
  State<WishlistCardWidget> createState() => _WishlistCardWidgetState();
}

class _WishlistCardWidgetState extends State<WishlistCardWidget> with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.98).animate(
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
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VehicleDetailsScreen(vehicleId: widget.vehicle.id),
            ),
          );
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isHovered ? 0.08 : 0.05),
                      blurRadius: isHovered ? 20 : 10,
                      offset: Offset(0, isHovered ? 10 : 5),
                      spreadRadius: isHovered ? 2 : 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section with Overlay
                    Stack(
                      children: [
                        Hero(
                          tag: 'wishlist_${widget.vehicle.id}',
                          child: Container(
                            height: 200.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                              image: DecorationImage(
                                image: NetworkImage(
                                  widget.vehicle.vehicleImage.isNotEmpty
                                      ? '$IMAGE_URL${widget.vehicle.vehicleImage[0]}'
                                      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtc3-y63KN_r5LwOC9PNqpwc5C1JPeN36_ug&s',
                                ),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.1),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.6),
                                      ],
                                      stops: [0.6, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Delivery Badge
                        if (widget.vehicle.vehicleAvailabilityStatus == 'Deliverable')
                          Positioned(
                            right: 16.w,
                            top: 16.h,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6.r),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF6C5CE7).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      HugeIcons.strokeRoundedCar02,
                                      color: Color(0xFF6C5CE7),
                                      size: 14.sp,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Home Delivery",
                                    style: TextStyle(
                                      color: Color(0xFF6C5CE7),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        // Vehicle Name and Price Overlay
                        Positioned(
                          bottom: 16.h,
                          left: 16.w,
                          right: 16.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.vehicle.vehicleName,
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12.r),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            color: Colors.amber,
                                            size: 18.sp,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            "4.9",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.attach_money_rounded,
                                    color: primaryColor,
                                    size: 20.sp,
                                  ),
                                  Text(
                                    "${widget.vehicle.vehicleDailyRate}/day",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Vehicle Specifications
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSpecItem(
                              icon: Icons.speed,
                              label: 'Engine',
                              value: '${widget.vehicle.vehicleEngineCc} CC',
                              color: Colors.blue,
                            ),
                            Container(height: 40.h, width: 1, color: Colors.grey[300]),
                            _buildSpecItem(
                              icon: Icons.speed_outlined,
                              label: 'Top Speed',
                              value: '${widget.vehicle.vehicleTopSpeed} km/h',
                              color: Colors.orange,
                            ),
                            Container(height: 40.h, width: 1, color: Colors.grey[300]),
                            _buildSpecItem(
                              icon: Icons.local_gas_station,
                              label: 'Mileage',
                              value: '${widget.vehicle.vehicleMileage} km/l',
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpecItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20.sp, color: color),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}