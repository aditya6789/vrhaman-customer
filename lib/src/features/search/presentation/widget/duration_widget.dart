import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';

class DurationWidget extends StatelessWidget {
  final String duration;
  const DurationWidget(
      {super.key, required this.isSelected, required this.duration});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: isSelected ? primaryColor : Colors.grey.shade300),
      ),
      child: Text(duration,
          style: extraSmallTextStyle.copyWith(
              color: isSelected ? Colors.white : Colors.black)),
    );
  }
}
