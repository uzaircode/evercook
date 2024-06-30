import 'package:evercook/core/common/widgets/custom_navigation_bar.dart';
import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/core/common/widgets/homepage/homepage.dart';
import 'package:evercook/core/common/widgets/homepage/recipe_list.dart';
import 'package:evercook/core/common/widgets/homepage/search_bar.dart';
import 'package:evercook/core/common/widgets/skeleton/skeleton_homepage.dart';
import 'package:evercook/core/cubit/app_user.dart';
import 'package:evercook/core/common/widgets/snackbar/show_fail_snackbar.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:evercook/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> display_list = [];
  List<Recipe> allRecipes = [];
  final TextEditingController textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final recipeState = context.read<RecipeBloc>().state;
    if (recipeState is! RecipeDisplaySuccess) {
      context.read<RecipeBloc>().add(RecipeFetchAllRecipes());
    }
    context.read<AppUserCubit>().fetchCurrentUser();
  }

  void updateList(String value) {
    setState(() {
      display_list = allRecipes.where((element) {
        final query = value.toLowerCase();
        final nameMatch = element.name?.toLowerCase().contains(query) ?? false;
        final ingredientsMatch = element.ingredients!.any((ingredient) => ingredient.toLowerCase().contains(query));
        final resourcesMatch = element.sources?.toLowerCase().contains(query) ?? false;

        return nameMatch || ingredientsMatch || resourcesMatch;
      }).toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CustomNavigationBar(
              largeTitle: 'Directory',
              middleTitle: 'Directory',
              heroTag: 'trans',
              leading: profileAvatar(context),
              trailing: searchButton(context),
            ),
          ];
        },
        body: BlocConsumer<RecipeBloc, RecipeState>(
          listener: (context, state) {
            if (state is RecipeFailure) showFailSnackbar(context, state.error);
          },
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const SkeletonHomepage();
            }
            if (state is RecipeDisplaySuccess) {
              allRecipes = List.from(state.recipes);

              if (display_list.isEmpty || !display_list.any((recipe) => allRecipes.contains(recipe))) {
                display_list = List.from(allRecipes);
              }

              return display_list.isEmpty
                  ? EmptyValue(
                      iconData: Icons.book_outlined,
                      description: 'No recipes in',
                      value: 'Directory',
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 28,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RecipeSearchBar(controller: textFieldController, onChanged: updateList),
                          SizedBox(height: 20),
                          RecipeList(recipes: display_list),
                        ],
                      ),
                    );
            }
            return Container(); // Or any other appropriate widget for default state
          },
        ),
      ),
    );
  }
}
