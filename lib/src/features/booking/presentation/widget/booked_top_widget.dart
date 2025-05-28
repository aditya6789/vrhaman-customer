import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookedTopWidget extends StatefulWidget {
  final TextEditingController controller;
  const BookedTopWidget({super.key, required this.controller});

  @override
  State<BookedTopWidget> createState() => _BookedTopWidgetState();
}

class _BookedTopWidgetState extends State<BookedTopWidget> {
  bool isSearchFocused = false;
  bool isFilterHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Focus(
              onFocusChange: (focused) {
                setState(() {
                  isSearchFocused = focused;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSearchFocused ? primaryColor : Colors.grey[200]!,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSearchFocused 
                        ? primaryColor.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                      blurRadius: isSearchFocused ? 12 : 8,
                      offset: Offset(0, isSearchFocused ? 6 : 4),
                      spreadRadius: isSearchFocused ? 2 : 0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: widget.controller,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[800],
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search your bookings...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    prefixIcon: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.all(12.w),
                      child: Icon(
                        HugeIcons.strokeRoundedSearch01,
                        color: isSearchFocused ? primaryColor : Colors.grey[400],
                        size: 20.sp,
                      ),
                    ),
                    suffixIcon: widget.controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            widget.controller.clear();
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.grey[400],
                            size: 20.sp,
                          ),
                        )
                      : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
          ),
        
        ],
      ),
    );
  }
}