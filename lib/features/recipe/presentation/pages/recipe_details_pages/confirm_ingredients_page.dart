import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/common/pages/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConfirmIngredientsPage extends StatefulWidget {
  static route(Recipe recipe) => MaterialPageRoute(builder: (context) => ConfirmIngredientsPage(recipe: recipe));
  final Recipe recipe;

  ConfirmIngredientsPage({Key? key, required this.recipe}) : super(key: key);

  @override
  _ConfirmIngredientsPageState createState() => _ConfirmIngredientsPageState();
}

class _ConfirmIngredientsPageState extends State<ConfirmIngredientsPage> {
  List<String> _selectedIngredients = [];

  @override
  void initState() {
    super.initState();
    // Initialize _selectedIngredients with all ingredients from the recipe
    _selectedIngredients = List<String>.from(widget.recipe.ingredients);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 46),
        child: widget.recipe.ingredients.isEmpty
            ? EmptyValue(
                iconData: Icons.question_mark_outlined,
                description: 'No ingredients in',
                value: 'Recipe',
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Groceries',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: widget.recipe.ingredients.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Color.fromARGB(255, 226, 227, 227),
                      ),
                      itemBuilder: (context, index) {
                        final ingredient = widget.recipe.ingredients[index];
                        return CheckboxListTile(
                          title: Text(
                            ingredient,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                          value: _selectedIngredients.contains(ingredient),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedIngredients.add(ingredient);
                              } else {
                                _selectedIngredients.remove(ingredient);
                              }
                            });
                          },
                          activeColor: Color.fromARGB(255, 221, 56, 32),
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_selectedIngredients.isNotEmpty) {
                          await _addSelectedIngredientsToShoppingList(_selectedIngredients);
                          Navigator.pushAndRemoveUntil(
                            context,
                            Dashboard.route(),
                            (route) => false,
                          );
                        } else {
                          // Handle the case when no ingredient is selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select at least one ingredient.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 221, 56, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_circle_down_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Confirm Ingredients',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  //todo separate to business logic
  Future<void> _addSelectedIngredientsToShoppingList(List<String> selectedIngredients) async {
    try {
      LoggerService.logger.i('Recipe ID: ${widget.recipe.id}, Ingredients: $selectedIngredients');
      for (String ingredient in selectedIngredients) {
        await Supabase.instance.client.rpc('add_to_shopping_lists', params: {
          'recipe_id': widget.recipe.id,
          'ingredient': ingredient,
        });
      }
    } catch (e) {
      LoggerService.logger.e(e.toString());
    }
  }
}
