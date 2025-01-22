import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vrhaman/constants.dart';
import 'package:vrhaman/src/features/booking/presentation/screens/booked_screen.dart';
import 'package:vrhaman/src/features/home/presentation/pages/home_screen.dart';
import 'package:vrhaman/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:vrhaman/src/features/search/presentation/screen/search_screen.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SearchScreen(),
    BookedScreen(),
    ProfileScreen(),
  ];

  final List<String> _labels = ['Home', 'Search', 'Bookings', 'Profile'];
  final List<IconData> _icons = [
    HugeIcons.strokeRoundedHome01,
    HugeIcons.strokeRoundedSearch01,
    HugeIcons.strokeRoundedBook02,
    HugeIcons.strokeRoundedUser,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 0,
            onTap: _onItemTapped,
            items: List.generate(
              _icons.length,
              (index) => BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedIndex == index
                        ? primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    _icons[index],
                    size: 24,
                    color: _selectedIndex == index
                        ? primaryColor
                        : Colors.grey,
                  ),
                ),
                label: _labels[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
