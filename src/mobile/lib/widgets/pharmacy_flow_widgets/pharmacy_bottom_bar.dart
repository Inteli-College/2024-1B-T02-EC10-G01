import 'package:asky/constants.dart';
import 'package:flutter/material.dart';

class PharmacyCustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const PharmacyCustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  _PharmacyCustomBottomNavigationBarState createState() => _PharmacyCustomBottomNavigationBarState();
}

class _PharmacyCustomBottomNavigationBarState extends State<PharmacyCustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Constants.askyBlue,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'Acompanhamento'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        
      ],
      currentIndex: widget.selectedIndex,
      onTap: widget.onTabChange,
    );
  }
}
