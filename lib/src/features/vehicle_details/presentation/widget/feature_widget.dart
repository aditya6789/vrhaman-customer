import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';

class FeatureWidget extends StatelessWidget {

  final String text;
  const FeatureWidget({
    super.key,
 
    required this.text,
  });

  String capitalizeText(String text) {
    List<String> words = text.split(' ');
    return words
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(HugeIcons.strokeRoundedCheckmarkCircle01,
            color: Colors.green,
            size: 24,
          ),
          SizedBox(width: 8),
          Text(capitalizeText(text),
              style: extraSmallTextStyle.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
