import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/profile/presentation/screens/account_information&edit_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
void completeProfile(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) => Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: BottomSheet(
            onClosing: () {},
            builder: (context) => Column(
              children: [
                const Icon(HugeIcons.strokeRoundedUserEdit01,
                    size: 60, color: primaryColor),
                SizedBox(height: 16.h),
                Text('Complete your profile ',
                    style:
                        mediumTextStyle.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 16.h),
                Text(
                    "Your profile is incomplete, please complete your profile to book this vehicle",
                    textAlign: TextAlign.center,
                    style: smallTextStyle.copyWith(color: Colors.grey)),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AccountInformationEditScreen()));

                                // Navigator.pop(context);
                    },
                    child: const Text('Complete Profile')),
              ],
            ),
          )));
}



void completedocument(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) => Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: BottomSheet(
            onClosing: () {},
            builder: (context) => Column(
              children: [
                const Icon(HugeIcons.strokeRoundedDocumentAttachment,
                    size: 60, color: primaryColor),
                SizedBox(height: 16.h),
                Text('Add your documents',
                    style:
                        mediumTextStyle.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 16.h),
                Text(
                    "Your documents are incomplete, please add your documents to book this vehicle",
                    textAlign: TextAlign.center,
                    style: smallTextStyle.copyWith(color: Colors.grey)),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AccountInformationEditScreen()));
                    },
                    child: const Text('Add Documents')),
              ],
            ),
          )));
}
