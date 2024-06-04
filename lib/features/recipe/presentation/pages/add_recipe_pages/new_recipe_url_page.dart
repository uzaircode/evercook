import 'dart:convert';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/recipe/presentation/pages/add_recipe_pages/add_new_recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewRecipeUrlPage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => NewRecipeUrlPage(),
      );

  const NewRecipeUrlPage({super.key});

  //todo separate to business logic
  Future<Map<String, dynamic>?> fetchRecipe(String recipeUrl) async {
    var url = Uri.parse('https://e394-2001-f40-94e-2131-f109-8d58-75fb-10ed.ngrok-free.app//recipe?url=$recipeUrl');
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
                color: Color.fromARGB(255, 221, 56, 32),
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
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            SizedBox(height: 16),
            Flexible(
              child: TextFormField(
                controller: urlController,
                decoration: InputDecoration(
                  hintText: 'Recipe URL',
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                maxLines: null,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
