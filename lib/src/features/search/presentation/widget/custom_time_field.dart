import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTimeField extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String hintText;
  final TextEditingController? controller;

  const CustomTimeField({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.hintText,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time != null && controller != null) {
            controller!.text = time.format(context);
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: iconColor, size: 20.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }
} 