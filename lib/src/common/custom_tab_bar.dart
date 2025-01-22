import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<String> tabTitles;
  final TabController tabController;

  @override
  Size get preferredSize => Size.fromHeight(65.h);

  const CustomTabBar({
    super.key,
    required this.tabTitles,
    required this.tabController,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with SingleTickerProviderStateMixin {
  late Animation<double> _fadeAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabSelection);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.tabController.animation!,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _handleTabSelection() {
    if (widget.tabController.indexIsChanging) {
      setState(() {
        _currentIndex = widget.tabController.index;
      });
    }
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabSelection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tabWidth = constraints.maxWidth / widget.tabTitles.length;
                  return TabBar(
                    controller: widget.tabController,
                    isScrollable: false,
                    labelPadding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    dividerColor: Colors.transparent,
                    labelColor: primaryColor,
                    unselectedLabelColor: Colors.grey[600],
                    labelStyle: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    splashFactory: NoSplash.splashFactory,
                    tabs: List.generate(
                      widget.tabTitles.length,
                      (index) => AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          final isSelected = _currentIndex == index;
                          return Container(
                            height: 45.h,
                            width: tabWidth,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeOutCubic,
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  constraints: BoxConstraints(
                                    maxWidth: tabWidth - 16.w,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isSelected) ...[
                                        TweenAnimationBuilder<double>(
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.easeOutCubic,
                                          tween: Tween(begin: 0.0, end: 1.0),
                                          builder: (context, value, child) {
                                            return Transform.scale(
                                              scale: value,
                                              child: Container(
                                                padding: EdgeInsets.all(4.r),
                                                margin: EdgeInsets.only(right: 4.w),
                                                decoration: BoxDecoration(
                                                  color: primaryColor.withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  size: 12.sp,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                      Flexible(
                                        child: Text(
                                          widget.tabTitles[index],
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: isSelected ? 15.sp : 14.sp,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                            color: isSelected ? primaryColor : Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String title;

  const TabItem({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
