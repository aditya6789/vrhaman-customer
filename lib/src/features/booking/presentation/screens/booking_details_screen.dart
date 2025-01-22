import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/booking/domain/entities/bookingVehicle.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


class BookingDetailsScreen extends StatelessWidget {
  final BookingVehicle bookingDetails;

  const BookingDetailsScreen({
    Key? key,
    required this.bookingDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Booking Details',
          style: mediumTextStyle
        ),
      ),
      
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            // Hero Vehicle Image Section with Enhanced Design
            Container(
              height: 300.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image with Enhanced Gradient
                  Hero(
                    tag: 'vehicle_${bookingDetails.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            IMAGE_URL + (bookingDetails.vehicleImages[0] ?? ''),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                  // Vehicle Info Overlay with Enhanced Layout
                  Positioned(
                    bottom: 40.h,
                    left: 20.w,
                    right: 20.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildStatusBadge(bookingDetails.status ?? 'Pending'),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.timer_outlined, color: Colors.white, size: 16.sp),
                                  SizedBox(width: 4.w),
                                  Text(
                                    bookingDetails.rentalPeriod ?? 'N/A',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          bookingDetails.vehicleName ?? 'Vehicle Name',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: Colors.white70, size: 16.sp),
                            SizedBox(width: 4.w),
                            Text(
                              'New Delhi, India',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content with Negative Margin for Card Overlap
            Transform.translate(
              offset: Offset(0, -30.h),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r),
                  ),
                ),
                child: Column(
                  children: [
                    // Booking Status Card with Enhanced Design
                    Container(
                      margin: EdgeInsets.fromLTRB(16.w, 24.w, 16.w, 16.w),
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(230, 255, 177, 59),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                            color: primaryColor.withOpacity(0.2),
                            blurRadius: 16,
                    offset: const Offset(0, 8),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 0,
                            offset: const Offset(0, -1),
                            spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildStatusRow('Booking ID', '#${bookingDetails.id ?? 'N/A'}'.substring(0, 8)),
                          _buildAnimatedDivider(isWhite: true),
               
                  _buildStatusRow('Status', bookingDetails.status ?? 'Pending', isStatus: true),
                ],
              ),
            ),

                    // Vehicle Details Card with Enhanced Design
            _buildDetailsCard(
              title: 'Vehicle Details',
              icon: Icons.directions_car,
              content: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.directions_car_outlined,
                    label: 'Vehicle',
                    value: bookingDetails.vehicleName ?? 'N/A',
                    iconColor: primaryColor,
                  ),
                  _buildAnimatedDivider(),
                  _buildDetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Start Date',
                    value: _formatDate(bookingDetails.startDate),
                    iconColor: primaryColor,
                  ),
                  _buildAnimatedDivider(),
                  _buildDetailRow(
                    icon: Icons.access_time_rounded,
                    label: 'Duration',
                    value: bookingDetails.rentalPeriod ?? 'N/A',
                    iconColor: primaryColor,
                  ),
                ],
              ),
            ),

                    // Payment Details Card with Enhanced Design
            _buildDetailsCard(
              title: 'Payment Details',
              icon: Icons.payment,
              content: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.receipt_long_outlined,
                    label: 'Total Amount',
                    value: '₹${bookingDetails.totalPrice ?? '0'}',
                    iconColor: Colors.green,
                            // isAmount: true,
                  ),
                  _buildAnimatedDivider(),
                  _buildDetailRow(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Payment Status',
                    value: bookingDetails.status ?? 'N/A',
                    iconColor: Colors.orange,
                  ),
                ],
              ),
            ),

                    // Vendor Details Card with Enhanced Design
            _buildDetailsCard(
              title: 'Vendor Details',
              icon: Icons.store,
              content: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.business,
                    label: 'Business Name',
                    value: bookingDetails.vendorBusinessName ?? 'N/A',
                    iconColor: Colors.blue[700]!,
                  ),
                  _buildAnimatedDivider(),
                  _buildDetailRow(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: bookingDetails.vendorBusinessAddress ?? 'N/A',
                    iconColor: Colors.red[600]!,
                  ),
                  _buildAnimatedDivider(),
                  _buildDetailRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone Number',
                    value: bookingDetails.vendorPhone ?? 'N/A',
                    iconColor: Colors.green[600]!,
                    isPhone: true,
                    onTap: () {
                      if (bookingDetails.vendorPhone != null) {
                        launch('tel:${bookingDetails.vendorPhone}');
                      }
                    },
                  ),
                  _buildAnimatedDivider(),
                  _buildDetailRow(
                    icon: Icons.phone_android_outlined,
                    label: 'Alternative Phone',
                    value: bookingDetails.vendorAlternativePhone ?? 'N/A',
                    iconColor: Colors.green[600]!,
                    isPhone: true,
                    onTap: () {
                      if (bookingDetails.vendorAlternativePhone != null) {
                        launch('tel:${bookingDetails.vendorAlternativePhone}');
                      }
                    },
                  ),
                ],
              ),
            ),

                    // Pickup Location Card with Enhanced Design
            _buildDetailsCard(
              title: 'Pickup Location',
              icon: Icons.location_on,
              content: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                  children: [
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.location_on, color: primaryColor, size: 24.sp),
                                ),
                    SizedBox(width: 12.w),
                    Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pickup Address',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                        bookingDetails.vendorBusinessAddress ?? 'N/A',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.black87,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.directions, size: 18.sp),
                              label: Text('Get Directions'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryColor,
                                side: BorderSide(color: primaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

                    // Action Buttons with Enhanced Design
            Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          if (bookingDetails.status?.toLowerCase() == 'pending')
                            Container(
                              width: double.infinity,
                              height: 50.h,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.cancel_outlined),
                                label: Text(
                                  'Cancel Booking',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[400],
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
            if (bookingDetails.payment_type == 'partial')
                            Column(
                              children: [
                                SizedBox(height: 12.h),
                                Container(
                                  width: double.infinity,
                                  height: 50.h,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Icon(Icons.payment),
                                    label: Text(
                                      'Make Full Payment',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Make full payment for hassle free pickup',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, {bool isOtp = false, bool isStatus = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
              color: Colors.black45,
            fontSize: 14.sp,
          ),
        ),
        if (isOtp || isStatus)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: isOtp ? 18.sp : 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: isOtp ? 3 : 0,
              ),
            ),
          )
        else
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
      ),
    );
  }

  Widget _buildDetailsCard({required String title, required Widget content, required IconData icon}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: primaryColor, size: 24.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          content,
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    bool isPhone = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: iconColor.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          value,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: isPhone ? primaryColor : Colors.black87,
                            fontWeight: isPhone ? FontWeight.w600 : FontWeight.w500,
                            decoration: isPhone ? TextDecoration.underline : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isPhone && onTap != null)
                        Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Icon(
                            Icons.call,
                            color: Colors.green[600],
                            size: 20.sp,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDivider({bool isWhite = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      height: 1,
      color: isWhite ? Colors.white.withOpacity(0.15) : Colors.grey[200],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            status.toUpperCase(),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
