import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/common/widgets/snackbar/show_success_snackbar.dart';
import 'package:evercook/core/common/widgets/snackbar/show_warning_snackbar.dart';
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
    _selectedIngredients = List<String>.from(widget.recipe.ingredients!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Container(
          child: TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 221, 56, 32),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 46),
        child: widget.recipe.ingredients!.isEmpty
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
                    'Shopping List',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      itemCount: widget.recipe.ingredients!.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        final ingredient = widget.recipe.ingredients![index];
                        return CheckboxListTile(
                          title: Text(
                            ingredient,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: _selectedIngredients.contains(ingredient)
                                      ? Theme.of(context).colorScheme.onBackground
                                      : Colors.grey,
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
                          checkColor: Colors.white,
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
                      onPressed: () {
                        if (_selectedIngredients.isNotEmpty) {
                          _addSelectedIngredientsToShoppingList(_selectedIngredients);
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showSuccessSnackBar(context, "Successfully added to grocery list");
                          });
                        } else {
                          showWarningSnackbar(context, 'Please select at least one ingredient');
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
                            Icons.add,
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
    final userId = Supabase.instance.client.auth.currentSession!.user.id;
    try {
      LoggerService.logger.i('Recipe ID: ${widget.recipe.id}, Ingredients: $selectedIngredients, UserId: $userId');
      for (String ingredient in selectedIngredients) {
        await Supabase.instance.client.rpc('add_to_shopping_lists', params: {
          'user_id': userId,
          'recipe_id': widget.recipe.id,
          'ingredient': ingredient,
        });
      }
    } catch (e) {
      LoggerService.logger.e(e.toString());
    }
  }
}
