import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/profile/presentation/screens/account_information&edit_screen.dart';
import 'package:vrhaman/src/utils/user_prefences.dart';
class ProfileInfoCardWidget extends StatefulWidget {
  const ProfileInfoCardWidget({
    super.key,
  });

  @override
  State<ProfileInfoCardWidget> createState() => _ProfileInfoCardWidgetState();
}

class _ProfileInfoCardWidgetState extends State<ProfileInfoCardWidget> {
  Map<String, dynamic>? userData;
  final user = UserPreferences();
  Future<void> _loadUserData() async {
    final data = await user.getUserData();
    setState(() {
      userData = data;
    });
  }
  @override
  void initState() {
    _loadUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AccountInformationEditScreen())).then(
                  (value) {
                    _loadUserData();
                  }
                );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            userData != null && userData!['name'] != null && userData!['name'].toString().isNotEmpty 
              ? userData!['name'] 
              : 'Unknown', 
            style: mediumTextStyle.copyWith(color: Colors.black, fontWeight: FontWeight.bold)
          ),
          subtitle: Text(
            userData != null && userData!['email'] != null && userData!['email'].toString().isNotEmpty 
              ? userData!['email'] 
              : 'unknown@gmail.com',
            style: smallTextStyle.copyWith(color: Colors.grey)
          ),
        ),
      ),
    );
  }
}
