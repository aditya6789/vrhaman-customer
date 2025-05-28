import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
void showLogout(BuildContext context){
  showModalBottomSheet(context: context, builder: (context) =>  Container(height: 200.h, padding: const EdgeInsets.all( 16), child: BottomSheet(
    onClosing: () {},
    builder: (context) => Column(
      children: [
        const Icon(HugeIcons.strokeRoundedLogout02, size: 60, color: primaryColor),
        SizedBox(height: 16.h),
        Text('Are you sure ?', style: mediumTextStyle.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 16.h),
        Text("You want to logout this application ?", textAlign: TextAlign.center, style: smallTextStyle.copyWith(color: Colors.grey)),
Spacer(),
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("No Return"))),
           SizedBox(width: 10,),
            Expanded(
              child: ElevatedButton(onPressed: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.clear();
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }, child: const Text('Yes Logout')),
            ),
          ],
        ),
      ],
    ),
  )));
}
