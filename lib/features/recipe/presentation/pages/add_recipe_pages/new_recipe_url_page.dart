import 'dart:convert';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/common/widgets/snackbar/show_fail_snackbar.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/recipe/presentation/pages/add_recipe_pages/add_new_recipe_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewRecipeUrlPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => NewRecipeUrlPage(),
      );
  const NewRecipeUrlPage({super.key});

  @override
  State<NewRecipeUrlPage> createState() => _NewRecipeUrlPageState();
}

class _NewRecipeUrlPageState extends State<NewRecipeUrlPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();
  bool isLoading = false;

  final List<String> supportedWebsites = [
    'tasty.co',
    'chenom.com',
    'cooking.nytimes',
    'delish.com',
    'foodnetwork.com',
    'food.com',
    'ambitiousKitchen.com',
    'bbcgoodfood.com',
    'joshuaweissman.com',
  ];

  //todo separate to business logic
  Future<Map<String, dynamic>?> fetchRecipe(String recipeUrl) async {
    var url = Uri.parse('https://thoroughly-causal-chipmunk.ngrok-free.app/recipe?url=$recipeUrl');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        LoggerService.logger.d(jsonResponse.toString());
        return jsonResponse;
      } else if (response.statusCode == 404) {
        throw Exception('Recipe not found');
      } else {
        throw Exception('Failed to load recipe');
      }
    } catch (e) {
      LoggerService.logger.e('Error fetching recipes: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  AppBar(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.all(8),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          CupertinoIcons.left_chevron,
                        ),
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              var jsonResponse = await fetchRecipe(_urlController.text);
                              LoggerService.logger.d(jsonResponse.toString());
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
                              }
                            } catch (e) {
                              if (e.toString().contains('Recipe not found')) {
                                LoggerService.logger.d(e.toString());
                                showFailSnackbar(context, "Recipe not found");
                              } else {
                                showFailSnackbar(context, "Server offline");
                              }
                              LoggerService.logger.e(e);
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
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
                  Form(
                    key: _formKey,
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
                        TextFormField(
                          controller: _urlController,
                          decoration: InputDecoration(
                            hintText: 'Enter recipe URL',
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Recipe URL is missing!';
                            }
                            return null;
                          },
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                        SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                height: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Supported Websites',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Column(
                          children: supportedWebsites.map((website) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  website,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Loader(),
              ),
            ),
        ],
      ),
    );
  }
}
