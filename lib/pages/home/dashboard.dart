import 'package:evercook/features/auth/presentation/pages/profile_page.dart';
import 'package:evercook/features/meal_plan/presentation/pages/view_meal_plan.dart';
import 'package:evercook/features/recipe/presentation/pages/home_page.dart';
import 'package:evercook/features/shopping_list/presentation/pages/shopping_list_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const Dashboard());
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = <Widget>[
    const HomePage(),
    // const SearchPage(),
    const ShoppingListPage(),
    const ViewMealPlan(),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 226, 227, 227),
            ),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            selectedItemColor: const Color.fromARGB(255, 244, 118, 160),
            backgroundColor: const Color.fromARGB(255, 249, 250, 250),
            unselectedItemColor: const Color.fromARGB(255, 167, 167, 167),
            enableFeedback: false,
            elevation: 0,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FaIcon(Icons.book_outlined),
                label: 'Recipes',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(Icons.shopping_bag_outlined),
                label: 'Groceries',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(Icons.calendar_month_outlined),
                label: 'Meal Plan',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
