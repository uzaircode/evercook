import 'package:evercook/core/theme/app_pallete.dart';
import 'package:evercook/features/recipe/presentation/pages/ingredient_wiki_list.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for recipes',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10.0,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Icon(Icons.search, size: 20),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(width: 1.0),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, IngredientWikiListPage.route());
              },
              child: Container(
                margin: const EdgeInsets.only(top: 16).copyWith(bottom: 4),
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
            )
          ],
        ),
      ),
    );
  }
}
