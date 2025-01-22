import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/themes/button_theme.dart';

class AppTheme {
  // Define your Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: whiteColor,
      foregroundColor: whiteColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: whiteColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    primaryColor: primaryColor,
    fontFamily: GoogleFonts.poppins().fontFamily,
    scaffoldBackgroundColor: Colors.white,
  
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: whiteColor),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: Colors.blueAccent,
      background: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    primaryTextTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
    useMaterial3: true,
     elevatedButtonTheme: elevatedButtonThemeData,
    outlinedButtonTheme: outlinedButtonThemeData
  );

  // Define your Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Color.fromRGBO(24, 28, 20, 1),
    fontFamily: GoogleFonts.poppins().fontFamily,
    appBarTheme:  AppBarTheme(
      backgroundColor: darkbackgroundColor,
     
      iconTheme: IconThemeData(color: Colors.white),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: Colors.black),
    ),
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: b),

    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: Colors.cyanAccent,
      background: Colors.black,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    useMaterial3: true,
    elevatedButtonTheme: elevatedButtonThemeData,
    outlinedButtonTheme: outlinedButtonThemeData
  );
}