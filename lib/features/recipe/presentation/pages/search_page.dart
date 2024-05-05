import 'package:evercook/core/theme/app_pallete.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/ingredient_wiki/presentation/pages/ingredient_wiki_list.dart';
import 'package:evercook/features/recipe/presentation/pages/profile_user_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _showIngredientGuides = true;

  void searchProfiles(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showIngredientGuides = true; // Hide the ingredient guides when the search field is empty
      });
      return;
    }

    final response = await Supabase.instance.client.from('profiles').select().textSearch('name', query);

    // Check if the data is null or not in the expected format
    final List<Map<String, dynamic>>? data = response as List<Map<String, dynamic>>?;
    if (data == null) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() {
      _searchResults = data
          .where((profile) => profile['name'] != null && profile['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
      _showIngredientGuides = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Profiles")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onTap: () {
                setState(() {
                  _showIngredientGuides = true; // Show the ingredient guides when the search field is tapped
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for users',
                contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Icon(Icons.search, size: 20),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(width: 1.0),
                ),
              ),
              onChanged: searchProfiles,
            ),
          ),
          if (_showIngredientGuides) // Show the ingredient guides only if _showIngredientGuides is true
            GestureDetector(
              onTap: () {
                Navigator.push(context, IngredientWikiListPage.route());
              },
              child: Container(
                margin: const EdgeInsets.only(top: 16, left: 10, right: 10).copyWith(bottom: 4),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppPallete.gradient1,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Ingredient Guides',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                    // Text('${calculateReadingTime(blog.content)} mins'),
                  ],
                ),
              ),
            ),
          if (_searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final profile = _searchResults[index];
                  LoggerService.logger.i(profile);
                  return ListTile(
                    title: Text(profile['name']),
                    onTap: () {
                      // Navigator.push(context, ProfilePage.route(profile['id']));
                      Navigator.push(context, ProfileUserPage.route(profile));
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
