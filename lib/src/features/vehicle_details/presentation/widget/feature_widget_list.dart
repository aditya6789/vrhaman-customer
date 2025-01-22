import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/entities/vehicleDetails.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/widget/feature_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_hugeicons/flutter_hugeicons.dart';

class FeatureWidgetList extends StatelessWidget {
  final VehicleDetails vehicleModel;
  const FeatureWidgetList({super.key, required this.vehicleModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...vehicleModel.features.map<Widget>((feature) {
      
          return FeatureWidget( text: feature);
        }).toList(),
        SizedBox(height: 8.h),
        GestureDetector(
          child: Text('Show all features',
              style: smallTextStyle.copyWith(
                  fontWeight: FontWeight.normal, color: primaryColor)),
        ),
      ],
    );
  }
}
