import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/cookbook/presentation/pages/add_cookbook_page.dart';
import 'package:evercook/features/cookbook/presentation/pages/cookbook_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CookbookPage extends StatefulWidget {
  @override
  _CookbookPageState createState() => _CookbookPageState();
}

class _CookbookPageState extends State<CookbookPage> {
  late Future<List<Map<String, dynamic>>> _cookbooksFuture;

  @override
  void initState() {
    super.initState();
    _cookbooksFuture = fetchCookbooksWithImages();
  }

  Future<List<Map<String, dynamic>>> fetchCookbooksWithImages() async {
    try {
      final userId = Supabase.instance.client.auth.currentSession!.user.id;

      // Fetch cookbook_ids associated with the current user
      final cookbookIdsResponse =
          await Supabase.instance.client.from('cookbook_recipes').select('cookbook_id').eq('user_id', userId);

      if (cookbookIdsResponse.isEmpty) {
        return [];
      }

      // Extract the list of cookbook IDs
      final List<String> cookbookIds = cookbookIdsResponse.map((row) => row['cookbook_id'] as String).toList();

      // Fetch cookbooks based on the fetched cookbook_ids
      final cookbooksResponse =
          await Supabase.instance.client.from('cookbooks').select('*').inFilter('id', cookbookIds);

      final List<Map<String, dynamic>> cookbooksWithImages = [];

      for (var cookbook in cookbooksResponse) {
        final cookbookId = cookbook['id'] as String;

        // Fetch recipes filtered by cookbook_id and user_id
        final recipesResponse = await Supabase.instance.client
            .from('cookbook_recipes')
            .select('recipes(image_url)')
            .eq('cookbook_id', cookbookId)
            .eq('user_id', userId)
            .limit(3);

        // Fetch the count of recipes filtered by cookbook_id and user_id
        final recipesCountResponse = await Supabase.instance.client
            .from('cookbook_recipes')
            .select('recipes(id)')
            .eq('cookbook_id', cookbookId)
            .eq('user_id', userId);

        final List<String> images = [];
        final recipes = recipesResponse;

        LoggerService.logger.i('data is $recipes');

        for (var recipe in recipes) {
          final recipeDetails = recipe['recipes'];
          final imageUrl = recipeDetails['image_url'] as String?;
          if (imageUrl != null && imageUrl.isNotEmpty) {
            images.add(imageUrl);
          }
        }

        if (recipes.isNotEmpty) {
          cookbooksWithImages.add({
            ...cookbook, // Add all cookbook data
            'images': images, // Add recipe image URLs
            'recipesCount': recipesCountResponse.length, // Add recipes count
          });
        }
      }

      LoggerService.logger.i('cookbook with images: $cookbooksWithImages');

      return cookbooksWithImages;
    } catch (e) {
      LoggerService.logger.e('Failed to fetch cookbooks: $e');
      return [];
    }
  }

  void _refreshCookbooks() {
    setState(() {
      _cookbooksFuture = fetchCookbooksWithImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              border: Border(),
              heroTag: 'notavailable',
              alwaysShowMiddle: false,
              largeTitle: Text(
                'Cookbook',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              middle: Text(
                'Cookbook',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 221, 56, 32),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCookbookPage()),
                  );

                  if (result == true) {
                    _refreshCookbooks();
                  }
                },
              ),
            ),
          ];
        },
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _cookbooksFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              LoggerService.logger.i('EXECUTED!!!!!!!!');
              final cookbooks = snapshot.data!;
              return GridView.builder(
                padding: EdgeInsets.only(top: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two items per row
                  childAspectRatio: 0.57, // Adjust the aspect ratio as needed
                  crossAxisSpacing: 0.0, // Spacing between items in the grid
                  mainAxisSpacing: 1, // Vertical spacing between items
                ),
                itemCount: cookbooks.length,
                itemBuilder: (context, index) {
                  final cookbook = cookbooks[index];
                  return CookbookCard(cookbook: cookbook);
                },
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              LoggerService.logger.i('EXECUTED!!!!! ELSEIF');
              return EmptyValue(
                iconData: Icons.collections_bookmark_outlined,
                description: 'No recipes in',
                value: 'Cookbook',
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching cookbooks'));
            }
            return Center(child: Loader());
          },
        ),
      ),
    );
  }
}

class CookbookCard extends StatelessWidget {
  final Map<String, dynamic> cookbook;

  const CookbookCard({required this.cookbook});

  @override
  Widget build(BuildContext context) {
    final title = cookbook['title'];
    final images = cookbook['images'] as List<String>;
    final recipesCount = cookbook['recipesCount'];

    return GestureDetector(
      onTap: () {
        LoggerService.logger.d(cookbook['id']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CookbookDetails(
              cookbookId: cookbook['id'],
              cookbookTitle: cookbook['title'],
            ),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0, // Remove shadow
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: images.isNotEmpty && images[0].isNotEmpty
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.onSecondaryContainer,
                    image: images.isNotEmpty && images[0].isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(images[0]),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: images.length > 1 && images[1].isNotEmpty
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.onSecondaryContainer,
                          image: images.length > 1 && images[1].isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(images[1]),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: images.length > 2 && images[2].isNotEmpty
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.onSecondaryContainer,
                          image: images.length > 2 && images[2].isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(images[2]),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${recipesCount.toString()} items',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
