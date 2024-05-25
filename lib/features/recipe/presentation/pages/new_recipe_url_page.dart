import 'dart:convert';

import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/recipe/presentation/pages/add_new_recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewRecipeUrlPage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => NewRecipeUrlPage(),
      );

  const NewRecipeUrlPage({super.key});

  Future<Map<String, dynamic>?> fetchRecipe(String recipeUrl) async {
    var url = Uri.parse('https://5f57-2001-f40-94e-2131-909-e39d-5cc9-1fd2.ngrok-free.app//recipe?url=$recipeUrl');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        LoggerService.logger.e('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      LoggerService.logger.e('Error fetching recipes: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController urlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              var jsonResponse = await fetchRecipe(urlController.text);
              if (jsonResponse != null) {
                Navigator.push(
                  context,
                  AddNewRecipePage.route(
                    imageUrl: jsonResponse['imageUrl'] ?? '',
                    title: jsonResponse['title'] ?? '',
                    description: jsonResponse['description'] ?? '',
                    prepTime: jsonResponse['prepTime'] ?? '',
                    cookTime: jsonResponse['cookTime'] ?? '',
                    servings: jsonResponse['servings'] ?? '',
                    directions: jsonResponse['instructions'] ?? '',
                    notes: jsonResponse['notes'] ?? '',
                    sources: jsonResponse['sources'] ?? '',
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to load recipe')),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Save Recipe From The Web',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: urlController,
              decoration: const InputDecoration(
                hintText: 'Recipe Url',
              ),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }
}
