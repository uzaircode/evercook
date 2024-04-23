import 'package:evercook/core/theme/app_pallete.dart';
import 'package:evercook/features/recipe/presentation/widgets/ingredient_wiki_card.dart';
import 'package:flutter/material.dart';

class IngredientWikiListPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => const IngredientWikiListPage(),
      );

  const IngredientWikiListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Wiki List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IngredientWikiCard(
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
      ),
    );
  }
}
