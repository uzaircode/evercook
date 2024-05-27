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
    var url = Uri.parse('https://eadb-2001-f40-94e-2131-853d-12e0-99a0-2c29.ngrok-free.app//recipe?url=$recipeUrl');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        LoggerService.logger.d(jsonResponse.toString());
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
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: const Color.fromARGB(255, 96, 94, 94),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                var jsonResponse = await fetchRecipe(urlController.text);
                LoggerService.logger.d(jsonResponse.toString);
                if (jsonResponse != null) {
                  Navigator.push(
                    context,
                    AddNewRecipePage.route(
                      name: jsonResponse['name'] ?? '',
                      description: jsonResponse['description'] ?? '',
                      servings: jsonResponse['servings'] ?? '',
                      imageUrl: jsonResponse['imageUrl'] ?? '',
                      prepTime: jsonResponse['prepTime'] ?? '',
                      cookTime: jsonResponse['cookTime'] ?? '',
                      ingredients: List<String>.from(jsonResponse['ingredients']),
                      directions: (jsonResponse['directions'] as List<dynamic>).join('\n\n'),
                      notes: jsonResponse['notes'] ?? '',
                      sources: jsonResponse['sources'] ?? '',
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to load recipe')),
                  );
                }
              } catch (e) {
                LoggerService.logger.e(e);
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 244, 118, 160),
              ),
            ),
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
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: 'Recipe URL',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
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
