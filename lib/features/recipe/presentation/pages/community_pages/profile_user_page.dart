import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/features/cookbook/presentation/pages/cookbook_page.dart';
import 'package:evercook/features/recipe/presentation/pages/community_pages/user_recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evercook/core/utils/logger.dart';

class ProfileUserPage extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const ProfileUserPage({Key? key, required this.profileData}) : super(key: key);

  static Route<dynamic> route(Map<String, dynamic> profileData) {
    return MaterialPageRoute(builder: (context) => ProfileUserPage(profileData: profileData));
  }

  @override
  ProfileUserPageState createState() => ProfileUserPageState();
}

class ProfileUserPageState extends State<ProfileUserPage> with TickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> _recipesFuture;
  late Future<List<Map<String, dynamic>>> _cookbooksFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = fetchRecipesByUserId(widget.profileData['id']);
    _cookbooksFuture = fetchCookbookByUserId();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No need to fetch recipes here again
  }

  //todo separate to business logic
  Future<List<Map<String, dynamic>>> fetchRecipesByUserId(String userId) async {
    final response = await Supabase.instance.client
        .from(DBConstants.recipesTable)
        .select()
        .eq(
          'user_id',
          userId,
        )
        .eq(
          'public',
          true,
        );
    LoggerService.logger.i('data of recipes of this particular user: $response');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchCookbookByUserId() async {
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
      final cookbooksResponse = await Supabase.instance.client
          .from('cookbooks')
          .select(
            '*',
          )
          .inFilter(
            'id',
            cookbookIds,
          )
          .eq('public', true);

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
      LoggerService.logger.i('data of cookbooks of this particular user: $cookbooksWithImages');

      return cookbooksWithImages;
    } catch (e) {
      LoggerService.logger.e('Failed to fetch cookbooks: $e');
      return [];
    }
  }

  // Future<List<Map<String, dynamic>>> fetchCookbookByUserId(String userId) async {
  //   final response = await Supabase.instance.client.from('cookbooks').select('*').eq('public', true);

  //   LoggerService.logger.i('data of cookbooks of this particular user: $response');
  //   return List<Map<String, dynamic>>.from(response).toList();
  // }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: const Color.fromARGB(255, 96, 94, 94),
          ),
        ),
        title: Text(
          widget.profileData['name'],
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const FaIcon(Icons.report_outlined),
            onPressed: () {
              // await Supabase.instance.client.from('reports').insert({
              //   'user_id': '',
              //   'type': '',
              //   'created_at': '',
              // });

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ReportOptionsDialog(userId: widget.profileData['id']);
                },
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color.fromARGB(255, 238, 198, 202),
                        backgroundImage: NetworkImage(
                          widget.profileData['avatar_url'] ?? 'https://robohash.org/${widget.profileData['id']}',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.profileData['name'] ?? 'Unknown User',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 20,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.profileData['bio'] ?? '',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: TabBar.secondary(
                    controller: _tabController,
                    labelColor: Color.fromARGB(255, 221, 56, 32),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color.fromARGB(255, 221, 56, 32),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bookmark),
                            const SizedBox(width: 8),
                            Text('Recipes'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.collections_bookmark_outlined),
                            const SizedBox(width: 8),
                            Text('Cookbooks'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _recipesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final recipes = snapshot.data!;
                      LoggerService.logger.i(recipes.toString());
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            mainAxisExtent: 270,
                          ),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserRecipePage(recipe: recipe),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      borderRadius: BorderRadius.circular(16),
                                      image: recipe['image_url'] != null && recipe['image_url']!.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                recipe['image_url'] ?? '',
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: recipe['image_url'] == null || recipe['image_url']!.isEmpty
                                        ? const Icon(
                                            Icons.image,
                                            size: 50,
                                            color: Colors.grey,
                                          )
                                        : null,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Text(
                                      recipe['name'] ?? 'Unnamed Recipe',
                                      style: Theme.of(context).textTheme.titleSmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Text('No recipes found.');
                    }
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReportOptionsDialog extends StatelessWidget {
  final String userId;

  final List<String> reportTypes = [
    'Nudity or pornography',
    'Graphic Violence',
    'Hateful Speech or Symbols',
    'Actively promotes self-harm',
    'Spam',
    'Other'
  ];

  ReportOptionsDialog({required this.userId});

  void _report(BuildContext context, String type) async {
    final client = Supabase.instance.client;
    await client.from('reports').insert({
      'user_id': userId,
      'type': type,
      'created_at': DateTime.now().toIso8601String(),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Report',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Please select the type of report',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              )),
          ...reportTypes.map((type) => ListTile(
                contentPadding: EdgeInsetsDirectional.zero,
                title: Text(
                  type,
                  style: TextStyle(
                    color: Color.fromARGB(255, 221, 56, 32),
                  ),
                ),
                onTap: () => _report(context, type),
              )),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancel', style: TextStyle(color: Colors.black)),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
