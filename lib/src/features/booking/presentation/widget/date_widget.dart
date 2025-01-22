import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';
import 'package:intl/intl.dart';


class DateWidget extends StatelessWidget {
  const DateWidget({
    super.key,
    required this.booking,
  });

  final BookingVehicle booking;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(HugeIcons.strokeRoundedCalendar01, size: 25.0),
            SizedBox(width: 4.0),
            Text(DateFormat('MMM dd, yyyy').format(booking.startDate), style: extraSmallTextStyle),
          ],
        ),
        
        SizedBox(height: 10.0),
        Row(
          children: [
            Icon(HugeIcons.strokeRoundedCalendar01, size: 25.0),
            SizedBox(width: 4.0),
            Text(DateFormat('MMM dd, yyyy').format(booking.endDate), style: extraSmallTextStyle),
          ],
        ),
       
      ],
    );
  }
}


