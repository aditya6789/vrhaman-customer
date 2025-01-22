import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/src/models/prediction.dart';
import 'package:vrhaman/src/utils/google_api.dart';

class PredictionListView extends StatelessWidget {
  final List<Prediction> predictions;
  final Function(Prediction) onPredictionTap;
  final Function(Prediction) onFavoriteTap;

  const PredictionListView({
    Key? key,
    required this.predictions,
    required this.onPredictionTap,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h), // Use ScreenUtil for padding
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: predictions.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final prediction = predictions[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5.w), // Use ScreenUtil for padding
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.all(8.w), // Use ScreenUtil for padding
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Icon(HugeIcons.strokeRoundedLocation01, size: 24.sp, color: Colors.grey), // Use ScreenUtil for icon size
              ),
             
              title: Text(
                prediction.description ?? '',
                style: TextStyle(fontSize: 14.sp), // Use ScreenUtil for text size
              ),
              onTap: () => onPredictionTap(prediction),
            ),
          );
        },
      ),
    );
  }
}
