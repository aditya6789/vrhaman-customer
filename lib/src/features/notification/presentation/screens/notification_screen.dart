// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:vrhaman/src/services/firebase_notifications.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   final FirebaseNotifications _firebaseNotifications = FirebaseNotifications();

//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//   }

//   Future<void> _initializeNotifications() async {
//     await _firebaseNotifications.initialize();
//     setState(() {}); // Update UI after loading saved notifications
    
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final notifications = _firebaseNotifications.messages;

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Text(
//           'Notifications',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: notifications.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.notifications_none,
//                     size: 80.sp,
//                     color: Colors.grey,
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     'No notifications yet',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Text(
//                     "We'll notify you when something arrives",
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: Colors.grey[400],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               padding: EdgeInsets.symmetric(vertical: 8.h),
//               itemCount: notifications.length,
//               itemBuilder: (context, index) {
//                 final notification = notifications[index];
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
//                   child: Card(
                    
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(16.sp),
//                       leading: Container(
//                         width: 48.w,
//                         height: 40.h,
//                         decoration: BoxDecoration(
//                           color: Colors.blue.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12.r),
//                         ),
//                         child: Icon(
//                           _getNotificationIcon(notification.notification?.title ?? ''),
//                           color: Colors.blue,
//                           size: 24.sp,
//                         ),
//                       ),
//                       title: Text(
//                         notification.notification?.title ?? 'No Title',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 4.h),
//                           Text(
//                             notification.notification?.body ?? 'No Body',
//                             style: TextStyle(
//                               fontSize: 12.sp,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           SizedBox(height: 4.h),
//                           Text(
//                             timeago.format(notification.sentTime ?? DateTime.now()),
//                             style: TextStyle(
//                               fontSize: 10.sp,
//                               color: Colors.grey[400],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   IconData _getNotificationIcon(String title) {
//     if (title.toLowerCase().contains('offer')) {
//       return Icons.local_offer;
//     } else if (title.toLowerCase().contains('booking')) {
//       return Icons.calendar_today;
//     } else if (title.toLowerCase().contains('payment')) {
//       return Icons.payment;
//     }
//     return Icons.notifications;
//   }
// }