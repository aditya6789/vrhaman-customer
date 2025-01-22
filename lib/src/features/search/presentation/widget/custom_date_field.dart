import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String hintText;
  final TextEditingController? controller;

  const CustomDateField({
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
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 365)),
          );
          if (date != null && controller != null) {
            controller!.text = DateFormat('dd/MM/yyyy').format(date);
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