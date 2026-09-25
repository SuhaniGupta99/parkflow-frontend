import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'customer_home_screen.dart';
import 'map_screen.dart';
import 'my_bookings_screen.dart';
import '../../core/widgets/navigation/pf_bottom_navigation.dart';
class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() =>
      _CustomerMainScreenState();
}

class _CustomerMainScreenState
    extends State<CustomerMainScreen> {

  int selectedIndex = 0;

  final pages = const [
    CustomerHomeScreen(),
    MapScreen(),
    MyBookingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar:
    PFBottomNavigation(

  currentIndex:
      selectedIndex,

  onTap: (index) {

    setState(() {

      selectedIndex =
          index;

    });

  },
),
    );
  }
}