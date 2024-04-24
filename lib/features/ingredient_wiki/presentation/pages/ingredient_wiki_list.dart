import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/theme/app_pallete.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/core/utils/show_snackbar.dart';
import 'package:evercook/features/ingredient_wiki/presentation/bloc/ingredient_wiki_bloc.dart';
import 'package:evercook/features/recipe/presentation/widgets/ingredient_wiki_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IngredientWikiListPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const IngredientWikiListPage(),
      );

  const IngredientWikiListPage({super.key});

  @override
  State<IngredientWikiListPage> createState() => _IngredientWikiListPageState();
}

class _IngredientWikiListPageState extends State<IngredientWikiListPage> {
  @override
  void initState() {
    super.initState();
    context.read<IngredientWikiBloc>().add(IngredientWikiFetchAllIngredients());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Wiki List'),
      ),
      body: BlocConsumer<IngredientWikiBloc, IngredientWikiState>(
        listener: (context, state) {
          if (state is IngredientWikiFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is IngredientWikiLoading) {
            LoggerService.logger.i('Ingredient Wiki Loading');
            return const Loader();
          }
          if (state is IngredientWikiDisplaySuccess) {
            LoggerService.logger.i('Ingredient Wiki Success: ${state.ingredients.length} ingredients');
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: state.ingredients.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: IngredientWikiCard(
                              ingredients: state.ingredients[index],
                              color: index % 2 == 0
                                  ? AppPallete.gradient1
                                  : index % 3 == 1
                                      ? AppPallete.gradient2
                                      : AppPallete.gradient3,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
