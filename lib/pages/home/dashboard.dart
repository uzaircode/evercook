import 'package:evercook/features/auth/presentation/pages/profile_page.dart';
import 'package:evercook/features/recipe/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const Dashboard());
  const Dashboard({Key? key}) : super(key: key); // Add a nullable key parameter

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0; // Index of the selected bottom navigation bar item

  late final List<Widget> _screens = <Widget>[
    const HomePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}