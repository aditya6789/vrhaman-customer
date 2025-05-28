import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/address/presentation/screens/address_screen.dart';
import 'package:vrhaman/src/features/document/presentation/screens/document_screen.dart';
import 'package:vrhaman/src/features/document/presentation/screens/upload_id_screen.dart';
import 'package:vrhaman/src/features/notification/presentation/screens/notification_screen.dart';
import 'package:vrhaman/src/features/profile/presentation/screens/help_support_screen.dart';
import 'package:vrhaman/src/features/profile/presentation/widget/profile_info_card_widget.dart';
import 'package:vrhaman/src/features/profile/presentation/widget/show_logout_bottomsheet.dart';
import 'package:vrhaman/src/features/wishlist/presentation/screens/wishlist_screen.dart';
import 'package:vrhaman/src/utils/api_response.dart';
import 'dart:ui';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  List? document;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    checkdocumentRequest();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> checkdocumentRequest() async {
    try {
      final response = await getRequest('document');
      if (response.statusCode == 200) {
        setState(() {
          document = response.data['data'];
        });
      }
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: Text('Profile Screen', style: bigTextStyle.copyWith(color: Colors.black , fontWeight: FontWeight.w500)),
      ),
      body: Stack(
        children: [
          // Background design elements
         
         
          // Main content
          SafeArea(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
               
                SliverToBoxAdapter(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [

                          SizedBox(height: 24.h),

                          const ProfileInfoCardWidget(),
                          SizedBox(height: 24.h),
                          _buildMenuSection(
                            title: 'Quick Actions',
                            items: [

                              _MenuItem(
                                icon: HugeIcons.strokeRoundedNotification02,
                                title: 'Notifications',
                                subtitle: 'Manage your notifications',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => NotificationScreen()));
                                },
                              ),

                              _MenuItem(
                                icon: HugeIcons.strokeRoundedDocumentAttachment,
                                title: 'Documents',
                                subtitle: 'Manage your documents',
                                onTap: () {
                                  if (document == null || document!.isEmpty) {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => UploadIDScreen()));
                                  } else {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => DocumentScreen()));
                                  }
                                },
                              ),
                              _MenuItem(
                                icon: HugeIcons.strokeRoundedHeartAdd,
                                title: 'Favorites',
                                subtitle: 'Your saved vehicles',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const WishlistScreen()));
                                },
                              ),
                              _MenuItem(
                                icon: HugeIcons.strokeRoundedAddressBook,
                                title: 'My Address',
                                subtitle: 'View your saved address',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const AddressScreen()));
                                },
                              ),

                            ],
                          ),
                          SizedBox(height: 24.h),

                          _buildMenuSection(
                            title: 'Support & Info',
                            items: [
                              _MenuItem(
                                icon: HugeIcons.strokeRoundedHelpCircle,
                                title: 'Help & Support',
                                subtitle: 'Get assistance',
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const HelpSupportScreen()));
                                },
                              ),
                              _MenuItem(
                                icon: HugeIcons.strokeRoundedInformationCircle,
                                title: 'Legal Information',
                                subtitle: 'Terms and privacy',
                                onTap: () {
                                 launchUrl(Uri.parse('https://www.vrhaman.com/privacy-policy'));
                                },
                              ),
                              // _MenuItem(
                              //   icon: HugeIcons.strokeRoundedInformationDiamond,
                              //   title: 'About Vrhaman',
                              //   subtitle: 'App information',
                              // ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          _buildLogoutButton(),
                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection({required String title, required List<_MenuItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w, bottom: 12.h),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: item.onTap,
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Icon(item.icon, color: primaryColor),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        item.subtitle,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12.sp,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16.sp,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (index < items.length - 1)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Divider(height: 1, color: Colors.black.withOpacity(0.05)),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton.icon(
        onPressed: () => showLogout(context),
        icon: Icon(HugeIcons.strokeRoundedLogoutSquare01),
        label: Text(
          'Log Out',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}
