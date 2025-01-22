import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';


class TimeWidget extends StatelessWidget {
  const TimeWidget({
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
            const Icon(HugeIcons.strokeRoundedClock01, size: 25.0),
            SizedBox(width: 4.0),
            Text(booking.startTime, style: extraSmallTextStyle),
          ],
        ),

        SizedBox(height: 10.0),
   
        Row(
          children: [
            const Icon(HugeIcons.strokeRoundedClock01, size: 25.0),
            SizedBox(width: 4.0),
            Text(booking.rentalPeriod, style: extraSmallTextStyle),
          ],
        ),
       
      ],
    );
  }
}
