import 'package:evercook/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Future<void> deleteRecipe(String recipeId) async {
  //   await supabase.from('recipes').delete().eq('id', recipeId);
  // }

  @override
  Widget build(BuildContext context) {
    // final _recipesStream = supabase.from('recipes').stream(primaryKey: ['id']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: null,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final recipes = snapshot.data!;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns in the grid
                      crossAxisSpacing: 1, // Spacing between columns
                      mainAxisSpacing: 10, // Spacing between rows
                    ),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print(recipes[index]['id']);
                            // Get.to(const RecipeDetails());
                            Get.toNamed(RoutesClass.recipeDetails, arguments: {
                              'name': recipes[index]['name'].toString(),
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(recipes[index]['name']),
                      ],
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
