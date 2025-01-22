import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



  Widget CheckListItem(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green , size: 30,),
          SizedBox(width: 8.w),
          Expanded(child: Text(text , style: smallTextStyle.copyWith(),)),
        ],
      ),
    );
  }

