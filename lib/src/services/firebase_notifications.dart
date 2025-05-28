import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class FirebaseNotifications {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // Define notification channel
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  // Initialize Firebase and setup push notifications
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    await _requestNotificationPermission();
    await _initLocalNotifications();
    _setupFirebaseMessaging();
  }

  // Request notification permission from the user
  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: true,
      criticalAlert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied or has not accepted permission');
    }
  }

  // Setup Firebase Messaging listeners
  void _setupFirebaseMessaging() {
    // Handle token generation
    _firebaseMessaging.getToken().then((token) async {
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcmToken', token);
      }
      print("FCM Token: $token");
      // Store or send this token to your server
    });

    // Handle token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcmToken', newToken);
      print("FCM Token refreshed: $newToken");
    });

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received in foreground!");
      print("Message data: ${message.data}");
      print("Message notification: ${message.notification?.title}, ${message.notification?.body}");
      
      _showLocalNotification(message);
      _saveNotificationToSharedPreferences(message);
    });

    // Handle when app is in background and user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A message was opened!');
      _saveNotificationToSharedPreferences(message);
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/home',
        (route) => false,
        arguments: 2, // Index 2 is for Booking tab
      );
    });

    // Handle when app is terminated and opened from notification
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _saveNotificationToSharedPreferences(message);
        Future.delayed(Duration(milliseconds: 500), () {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
            arguments: 2, // Index 2 is for Booking tab
          );
        });
      }
    });
  }

  // Initialize local notifications
  Future<void> _initLocalNotifications() async {
    // Create the Android notification channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Navigate to booking screen when notification is tapped
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/home',
          (route) => false,
          arguments: 2, // Index 2 is for Booking tab
        );
      },
    );
  }

  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print('iOS local notification: $id, $title, $body, $payload');
  }

  // Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'app_icon',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
     

          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: json.encode(message.data),
      );
    } else {
      // If no notification payload is received, still show a notification with the data
      await _flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.data['title'] ?? 'New Notification',
        message.data['body'] ?? 'You have a new notification',
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  }

  // Save notification to SharedPreferences
  Future<void> _saveNotificationToSharedPreferences(RemoteMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notifications = prefs.getStringList('notifications') ?? [];

    final notificationData = {
      'title': message.notification?.title ?? message.data['title'] ?? 'No Title',
      'body': message.notification?.body ?? message.data['body'] ?? 'No Body',
      'data': message.data,
      'timestamp': DateTime.now().toIso8601String(),
    };

    notifications.add(jsonEncode(notificationData));
    await prefs.setStringList('notifications', notifications);
    print('Notification saved to SharedPreferences: $notificationData');
  }

  // Fetch all notifications from SharedPreferences
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notifications = prefs.getStringList('notifications') ?? [];

    return notifications.map((notification) => jsonDecode(notification) as Map<String, dynamic>).toList();
  }
}
