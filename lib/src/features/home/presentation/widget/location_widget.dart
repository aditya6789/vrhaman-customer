import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationWidget extends StatelessWidget {
  final String cityName;
  const LocationWidget({
    super.key,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          color: primaryColor,
          size: 25.sp,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            cityName,
            style: bigTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
