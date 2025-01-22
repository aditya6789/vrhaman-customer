
import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';

ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(defaultPadding),
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 32),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
    ),
  ),
);
OutlinedButtonThemeData outlinedButtonThemeData = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.all(defaultPadding),
    minimumSize: const Size(double.infinity, 32),
    side: const BorderSide(width: 1.5, color: blackColor10),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
    ),
  ),
);

final textButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(foregroundColor: primaryColor),
);