import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';

class CustomAutoCompleteTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final Color fillColor;
  final Color textColor;
  final Color hintTextColor;
  final Color borderColor;
  final VoidCallback? onTap;
  final VoidCallback? currentlocation;
  final IconData? icon;

  final Color? iconColor;
  final Function(String) onChanged;

  const CustomAutoCompleteTextField({
    required this.textEditingController,
    required this.hintText,
    required this.fillColor,
    required this.textColor,
    required this.hintTextColor,
    required this.borderColor,
    required this.onChanged,
    this.currentlocation,
    this.onTap,
    this.icon,
    this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

      
    return
        TextField(
          onTap: onTap,
          controller: textEditingController,
          onChanged: onChanged,
          style: smallTextStyle,
           decoration: InputDecoration(
            filled: true,
            // fillColor: fillColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                      // borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(HugeIcons.strokeRoundedSearch01 , color: Colors.black87,),
                    suffixIcon: GestureDetector(
                      onTap: currentlocation,
                      child: Icon(HugeIcons.strokeRoundedGps01, color: Colors.blue.shade800,)),
                    hintText: 'Search for the location',
                   
                    hintStyle: smallTextStyle.copyWith(color: Colors.black87),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
        );
  }
}
