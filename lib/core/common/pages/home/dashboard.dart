import 'package:evercook/features/cookbook/presentation/pages/cookbook_page.dart';
import 'package:evercook/features/meal_plan/presentation/pages/view_meal_plan.dart';
import 'package:evercook/core/common/pages/home/home_page.dart';
import 'package:evercook/features/grocery/presentation/pages/grocery_page.dart';
import 'package:evercook/features/recipe/presentation/pages/add_recipe_pages/add_new_recipe_page.dart';
import 'package:evercook/features/recipe/presentation/pages/add_recipe_pages/new_recipe_url_page.dart';
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
    CookbookPage(),
    const GroceryPage(),
    const ViewMealPlan(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Index of the "Add" button
      _showAddRecipeBottomSheet(context);
    } else {
      setState(() {
        _selectedIndex = index > 2 ? index - 1 : index;
      });
    }
  }

  Future<dynamic> _showAddRecipeBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          padding: EdgeInsets.all(16),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add New Recipe',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Divider(),
              ListTile(
                leading: Icon(Icons.link_outlined),
                title: Text(
                  'Save Recipe From the Web',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0.5),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    NewRecipeUrlPage.route(),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.edit_note_outlined),
                title: Text(
                  'Create New Recipe',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 2),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    AddNewRecipePage.route(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
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
            currentIndex: _selectedIndex >= 2 ? _selectedIndex + 1 : _selectedIndex,
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
                icon: FaIcon(Icons.collections_bookmark_outlined),
                label: 'Cookbook',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.squarePlus),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(Icons.shopping_bag_outlined),
                label: 'Shopping',
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
