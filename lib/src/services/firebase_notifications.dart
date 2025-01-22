// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class FirebaseNotifications {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   final List<RemoteMessage> _messages = [];

//   List<RemoteMessage> get messages => _messages;

//   Future<void> initialize() async {
//     try {
//       // Request permission first
//       NotificationSettings settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false,
//       );
      
//       print('User granted permission: ${settings.authorizationStatus}');

//       // Initialize local notifications first
//       await _initLocalNotifications();
//       print('Local notifications initialized');

//       // Load saved notifications
//       await _loadSavedNotifications();
//       print('Saved notifications loaded');

//       // Set up message handlers
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         print('Received foreground message: ${message.messageId}');
//         addMessage(message);
//         _showLocalNotification(message);
//       });

//       // Set up background message handler
//       FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//       print('Background message handler set up');

//       // Get FCM token last
//       try {
//         String? token = await _firebaseMessaging.getToken();
//         if (token != null) {
//           print('Successfully retrieved FCM token: $token');
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('fcmToken', token);
//         } else {
//           print('FCM token is null');
//           // Schedule a retry
//           Future.delayed(Duration(seconds: 5), () async {
//             token = await _firebaseMessaging.getToken();
//             if (token != null) {
//               print('Successfully retrieved FCM token on retry: $token');
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.setString('fcmToken', token.toString());
//             }
//           });
//         }
//       } catch (e) {
//         print('Error getting FCM token: $e');
//       }
      
//     } catch (e) {
//       print('Error initializing Firebase Notifications: $e');
//     }
//   }

//   Future<void> _initLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       channelDescription: 'channel_description',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title ?? 'Notification Title',
//       message.notification?.body ?? 'Notification Body',
//       platformChannelSpecifics,
//     );
//   }

//   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     print('Handling a background message: ${message.messageId}');
//     try {
//       await Firebase.initializeApp();
//       print('Firebase initialized in background handler');
//     } catch (e) {
//       print('Error initializing Firebase in background handler: $e');
//     }
//   }

//   Future<void> _saveNotifications() async {
//     final prefs = await SharedPreferences.getInstance();
//     final notificationsJson = _messages.map((msg) => {
//       'title': msg.notification?.title,
//       'body': msg.notification?.body,
//       'sentTime': msg.sentTime?.toIso8601String(),
//     }).toList();
    
//     // Sort notifications by time before saving
//     notificationsJson.sort((a, b) {
//       final DateTime? timeA = a['sentTime'] != null ? DateTime.parse(a['sentTime']!) : null;
//       final DateTime? timeB = b['sentTime'] != null ? DateTime.parse(b['sentTime']!) : null;
//       if (timeA == null || timeB == null) return 0;
//       return timeB.compareTo(timeA); // Newest first
//     });
    
//     await prefs.setString('notifications', jsonEncode(notificationsJson));
//   }

//   Future<void> _loadSavedNotifications() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedNotifications = prefs.getString('notifications');
//     if (savedNotifications != null) {
//       final List<dynamic> decoded = jsonDecode(savedNotifications);
//       _messages.clear();
      
//       // No need to reverse since data is already sorted
//       for (var msg in decoded) {
//         final notification = RemoteNotification(
//           title: msg['title'],
//           body: msg['body'],
//         );
//         final remoteMessage = RemoteMessage(
//           notification: notification,
//           sentTime: msg['sentTime'] != null ? DateTime.parse(msg['sentTime']) : null,
//         );
//         _messages.add(remoteMessage);
//       }
//     }
//   }

//   void addMessage(RemoteMessage message) {
//     // Add new message and sort the list
//     _messages.insert(0, message);
//     _messages.sort((a, b) => 
//       (b.sentTime ?? DateTime.now()).compareTo(a.sentTime ?? DateTime.now())
//     );
//     _saveNotifications();
//   }
// }
