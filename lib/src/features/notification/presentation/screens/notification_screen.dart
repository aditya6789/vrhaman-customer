import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/services/firebase_notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseNotifications _firebaseNotifications = FirebaseNotifications();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final notifications = await _firebaseNotifications.fetchNotifications();
      if (mounted) {
        setState(() {
          // Sort notifications by timestamp in descending order (latest first)
          _notifications = notifications..sort((a, b) => 
            DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp']))
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    
    // Listen for new notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _refreshNotifications();
    });
  }
  
  Future<void> _refreshNotifications() async {
    try {
      final notifications = await _firebaseNotifications.fetchNotifications();
      if (mounted) {
        setState(() {
          // Sort notifications by timestamp in descending order (latest first)
          _notifications = notifications..sort((a, b) => 
            DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp']))
          );
        });
      }
    } catch (e) {
      print('Error refreshing notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black87, size: 20.sp),
            onPressed: _refreshNotifications,
          ),
        ],
      ),
      body: _isLoading 
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshNotifications,
              color: primaryColor,
              child: _notifications.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(24.sp),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_none_rounded,
                                size: 64.sp,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              'No Notifications Yet',
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "We'll notify you when something arrives",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                                letterSpacing: 0.2,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              "Pull down to refresh",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[400],
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      final DateTime timestamp = DateTime.parse(notification['timestamp']);
                      
                      return Dismissible(
                        key: Key(notification['timestamp']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.w),
                          color: Colors.red,
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          // Implement deletion logic later
                          setState(() {
                            _notifications.removeAt(index);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.sp),
                            leading: Container(
                              width: 48.w,
                              height: 48.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [primaryColor.withOpacity(0.2), primaryColor.withOpacity(0.1)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Icon(
                                _getNotificationIcon(notification['title']),
                                color: primaryColor,
                                size: 24.sp,
                              ),
                            ),
                            title: Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Text(
                                notification['title'] ?? 'No Title',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification['body'] ?? 'No Body',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  timeago.format(timestamp),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
    );
  }

  IconData _getNotificationIcon(String title) {
    final String lowercaseTitle = title.toLowerCase();
    if (lowercaseTitle.contains('offer')) {
      return Icons.local_offer_rounded;
    } else if (lowercaseTitle.contains('booking')) {
      return Icons.calendar_today_rounded;
    } else if (lowercaseTitle.contains('payment')) {
      return Icons.payments_rounded;
    }
    return Icons.notifications_rounded;
  }
}