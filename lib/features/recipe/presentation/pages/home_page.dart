import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:evercook/features/recipe/presentation/pages/add_new_recipe_page.dart';
import 'package:evercook/features/recipe/presentation/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    context.read<RecipeBloc>().add(RecipeFetchAllRecipes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                AddNewRecipePage.route(),
                (route) => false,
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
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: state.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = state.recipes[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RecipeCard(
                          recipe: recipe,
                        ),
                        const SizedBox(height: 10),
                        Text(recipe.title),
                      ],
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
