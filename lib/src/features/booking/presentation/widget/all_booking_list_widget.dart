import 'package:flutter/material.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';
import 'package:vrhaman/src/features/booking/presentation/widget/booked_vehicle_info_card_widget.dart';


class AllBookingList extends StatelessWidget {
  final List<BookingVehicle> bookings;

  AllBookingList({required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return BookedVehicleInfoCard(booking: booking,); 
        },
      ),
    );
  }
}
