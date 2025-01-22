import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleDetailInfo extends StatelessWidget {
  final VehicleDetails vehicleModel;
  const VehicleDetailInfo({super.key, required this.vehicleModel});

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: color,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Host info and Price Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Host info
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Hosted by ${vehicleModel.bussinessName}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Price
             
            ],
          ),
          SizedBox(height: 16.h),
          
          // Vehicle name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                vehicleModel.name,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
               Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      size: 16.sp,
                      color: primaryColor,
                    ),
                    Text(
                      '${vehicleModel.dailyPrice}/day',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          
          // Vehicle details
          Text(
            '${vehicleModel.year} • ${vehicleModel.variant}',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Status Chips
          Row(
            children: [
              _buildInfoChip(
                vehicleModel.availabilityStatus,
                Icons.check_circle,
                Colors.green[700]!,
              ),
              SizedBox(width: 8.w),
              _buildInfoChip(
                vehicleModel.availableDelivery,
                Icons.delivery_dining,
                Colors.blue[700]!,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 4.w,
            runSpacing: 4.h,
            children: [
              Icon(Icons.info_outline, size: 16.sp, color: Colors.grey[500],),
              SizedBox(width: 4.w),
              Text('Prices are different according to duration of booking', style: extraSmallTextStyle.copyWith(color: Colors.grey[500]),),
            ],
          )
         
          
          // Location
          
        ],
      ),
    );
  }
}
