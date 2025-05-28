import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrhaman/src/common/custom_tab_bar.dart';
import 'package:vrhaman/src/common/loading.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';
import 'package:vrhaman/src/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:vrhaman/src/features/booking/presentation/widget/all_booking_list_widget.dart';
import 'package:vrhaman/src/features/booking/presentation/widget/booked_top_widget.dart';
import 'package:vrhaman/src/features/booking/presentation/widget/no_booking_widget.dart';

class BookedScreen extends StatefulWidget {
  @override
  _BookedScreenState createState() => _BookedScreenState();
}

class _BookedScreenState extends State<BookedScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  List<BookingVehicle> _allBookings = [];
  List<BookingVehicle> _filteredBookings = [];
  List<BookingVehicle> _pastBookings = [];
  List<BookingVehicle> _upcomingBookings = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookingCubit>(context).getBookings();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_filterBookings);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterBookings() {
    final query = _searchController.text.toLowerCase();
    final now = DateTime.now();
    setState(() {
      _filteredBookings = _allBookings.where((booking) {
        final bookingId = booking.id.toString().toLowerCase();
        final vehicleName = booking.vehicleName.toString().toLowerCase();
        return bookingId.contains(query) || vehicleName.contains(query);
      }).toList();

      _pastBookings = _filteredBookings.where((booking) {
        return booking.endDate.isBefore(now);
      }).toList();

      _upcomingBookings = _filteredBookings.where((booking) {
        return booking.startDate.isAfter(now);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Booking History',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  BookedTopWidget(controller: _searchController),
                  SizedBox(height: 20),
                  CustomTabBar(
                    tabController: _tabController,
                    tabTitles: const ['All', 'Past', 'Upcoming'],
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocListener<BookingCubit, BookingState>(
                listener: (context, state) {
                  if (state is GetBookingsSuccess) {
                    // Update bookings and filter outside build
                    setState(() {
                      _allBookings = state.data.cast<BookingVehicle>();
                      _filterBookings();
                    });
                  }
                },
                child: BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    if (state is GetBookingsLoading) {
                      return const Loading();
                    } else if (state is GetBookingsSuccess) {
                      return TabBarView(
                        controller: _tabController,
                        children: [
                          _filteredBookings.isEmpty
                              ? NoBookingWidget(text: 'No Bookings Found')
                              : AllBookingList(bookings: _filteredBookings),
                          _pastBookings.isEmpty
                              ? NoBookingWidget(text: 'No Past Bookings')
                              : AllBookingList(bookings: _pastBookings),
                          _upcomingBookings.isEmpty
                              ? NoBookingWidget(text: 'No Upcoming Bookings')
                              : AllBookingList(bookings: _upcomingBookings),
                        ],
                      );
                    } else if (state is GetBookingsError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return NoBookingWidget(text: 'No Bookings Found');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
