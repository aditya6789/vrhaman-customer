import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/address/presentation/cubit/address_cubit.dart';
import 'package:vrhaman/src/features/address/presentation/screens/address_screen.dart';
import 'package:vrhaman/src/utils/toast.dart';

Future<String?> showAddressBottomSheet(BuildContext context) async {
  String? selectedAddressId;

  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Address',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Select Delivery Address',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddressScreen()));
                    },
                    icon: Icon(Icons.add_circle_outline),
                    color: primaryColor,
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<AddressCubit, AddressState>(
                builder: (context, state) {
                  if (state is AddressLoading) {
                    return Center(child: CircularProgressIndicator(color: primaryColor));
                  } else if (state is AddressLoaded) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      itemCount: state.addressModel.addresses.length,
                      itemBuilder: (context, index) {
                        final address = state.addressModel.addresses[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(12.w),
                            leading: CircleAvatar(
                              backgroundColor: primaryColor.withOpacity(0.1),
                              child: Icon(
                                HugeIcons.strokeRoundedLocation01,
                                color: primaryColor,
                              ),
                            ),
                            subtitle: Text(
                              '${address.address}, ${address.city}\n${address.state} - ${address.postalCode}',
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: Radio(
                              value: address.id,
                              groupValue: selectedAddressId,
                              onChanged: (value) {
                                setState(() {
                                  selectedAddressId = value as String;
                                });
                              },
                              activeColor: primaryColor,
                            ),
                            onTap: () {
                              setState(() {
                                selectedAddressId = address.id;
                              });
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No addresses found'));
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedAddressId != null) {
                      Navigator.pop(context, selectedAddressId);
                    } else {
                     showToast('Please select an address' , isSuccess: false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Confirm Address',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  return result;
}
