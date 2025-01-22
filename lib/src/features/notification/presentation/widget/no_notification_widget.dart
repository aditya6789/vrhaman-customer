import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vrhaman/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class NoNotificationWidget extends StatelessWidget {
  const NoNotificationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/images/message.json' , width: 150.w, height: 150.h,),
          SizedBox(height: 20.h),
          Text('No notifications', style:bigTextStyle.copyWith(color: Colors.black)),
          SizedBox(height: 10.h),
          Text('You will see your notifications here', style:smallTextStyle.copyWith(color: Colors.black)),
        ],
      ),
    );
  }
}