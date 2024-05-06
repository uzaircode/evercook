// TODO: only show the intended user id recipe card
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:evercook/features/recipe/presentation/pages/add_new_recipe_page.dart';
import 'package:evercook/features/recipe/presentation/widgets/recipe_card.dart';
import 'package:evercook/features/shopping_list/presentation/pages/shopping_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    fetchRecipe();
    context.read<RecipeBloc>().add(RecipeFetchAllRecipes());
  }

  Future<void> fetchRecipe() async {
    var url = Uri.parse(
        'https://3a12-2001-f40-94e-2131-8d0a-f661-552-e6ba.ngrok-free.app/recipe?url=https://resepichenom.com/resepi/ayam-masak-cabai-bersantan/show');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        LoggerService.logger.i(jsonResponse.toString());
      } else {
        LoggerService.logger.e('Request failed with status: ${response.statusCode}');
        showSnackBar(context, 'Failed to load recipes: Server error ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.logger.e('Error fetching recipes: $e');
      showSnackBar(context, 'Failed to load recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, ShoppingListPage.route());
            },
            icon: const Icon(Icons.local_grocery_store),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                AddNewRecipePage.route(),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocConsumer<RecipeBloc, RecipeState>(
        listener: (context, state) {
          if (state is RecipeFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Loader();
          }
          if (state is RecipeDisplaySuccess) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: state.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = state.recipes[index];
                    return GridTile(
                      child: RecipeCard(
                        recipe: recipe,
                      ),
                    );
                  },
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
