import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrhaman/firebase_options.dart';
import 'package:vrhaman/src/services/firebase_notifications.dart';
import 'package:vrhaman/src/utils/api_response.dart';
import 'package:vrhaman/src/utils/user_prefences.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';


// Future<void> saveTokenToFirebase() async {
//   final prefs = await SharedPreferences.getInstance();
//   final fcmToken = prefs.getString('fcmToken');
//   final userId = await UserPreferences().getUserId();
//   if (userId != null) {
//     print('User ID: $userId');
//   } else {
//     print('User ID not found');
//   }

//   if (fcmToken != null) {
//     final response = await postRequest(
//       'token/',
//       {'fcmToken': fcmToken, 'user_type': 'Customer'},
//     );

//     if (response.statusCode == 200) {
//       print('Token successfully sent to backend');
//     } else {
//       print('Failed to send token to backend: ${response.data}');
//     }
//   } else {
//     print('FCM Token not found');
//   }
// }

// Future<bool> checkFcmToken() async {
//   print('Checking FCM token');
//   final userId = await UserPreferences().getUserId();
//   if (userId == null) {
//     print('User ID not found');
//     return false;
//   }

//   try {
//     final response = await getRequest('token');

//     if (response.statusCode == 200) {
//       print('Response data: ${response.data}');
//       final data = response.data as Map<String, dynamic>;
//       print('Data: $data');
//       if (data['exists'] == true) {
//         print('FCM token exists for user');
//         return true;
//       } else {
//         print('No FCM token found for user');
//         return false;
//       }
//     } else {
//       print('Failed to check FCM token: ${response.data}');
//       return false;
//     }
//   } catch (e) {
//     print('Error checking FCM token: $e');
//     return false;
//   }
// }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
  } catch (e) {
    print('Firebase initialization failed: $e');
    
  }
  
  // try {
  //   print('Initializing Firebase...');
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   print('Firebase initialized successfully');
    
  //   print('Initializing Firebase Notifications...');
  //   FirebaseNotifications firebaseNotifications = FirebaseNotifications();
  //   await firebaseNotifications.initialize();
  //   print('Firebase Notifications initialized');

  //   final settingsController = SettingsController(SettingsService());
  //   await settingsController.loadSettings();
    
  //   // Start the app immediately
  //   runApp(MyApp(settingsController: settingsController));

  //   // Check FCM token in the background
  //   Future.microtask(() async {
  //     print('Checking FCM token...');
  //     bool fcmTokenExists = await checkFcmToken();
  //     print('FCM token exists: $fcmTokenExists');

  //     if (!fcmTokenExists) {
  //       print('Saving FCM token to Firebase...');
  //       await saveTokenToFirebase();
  //     }
  //   });
  // } catch (e, stackTrace) {
  //   print('Error in initialization: $e');
  //   print('Stack trace: $stackTrace');
  //   // Still run the app even if Firebase fails
    final settingsController = SettingsController(SettingsService());
  //   await settingsController.loadSettings();
    runApp(MyApp(settingsController: settingsController));
  // }
}
