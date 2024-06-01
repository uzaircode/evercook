import 'package:evercook/features/meal_plan/presentation/pages/view_meal_plan.dart';
import 'package:evercook/core/common/pages/home/home_page.dart';
import 'package:evercook/features/grocery/presentation/pages/grocery_page.dart';
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
    const GroceryPage(),
    const ViewMealPlan(),
    // _buildNavigator(const HomePage(), 'Home'),
    // _buildNavigator(const ShoppingListPage(), 'Shopping'),
    // _buildNavigator(const ViewMealPlan(), 'Meal Plan'),
  ];

  // static Widget _buildNavigator(Widget page, String routeName) {
  //   return Navigator(
  //     onGenerateRoute: (settings) {
  //       return MaterialPageRoute(
  //         builder: (context) => page,
  //         settings: RouteSettings(name: routeName),
  //       );
  //     },
  //   );
  // }

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
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
                  ? Color.fromARGB(255, 226, 227, 227)
                  : Color(0xFF3F3F3F),
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
            ],
          ),
        ),
      ),
    );
  }
}
