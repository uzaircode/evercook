import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/common/widgets/snackbar/show_success_snackbar.dart';
import 'package:evercook/features/cookbook/presentation/pages/cookbook_page.dart';
import 'package:evercook/features/recipe/presentation/pages/community_pages/user_recipe_page.dart';
import 'package:evercook/features/recipe/presentation/pages/community_pages/widget/UserCookbookDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    _cookbooksFuture = fetchCookbookByUserId(widget.profileData['id']);
  }

  Future<List<Map<String, dynamic>>> fetchRecipesByUserId(String userId) async {
    final response =
        await Supabase.instance.client.from(DBConstants.recipesTable).select().eq('user_id', userId).eq('public', true);
    LoggerService.logger.i('data of recipes of this particular user: $response');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchCookbookByUserId(String userId) async {
    try {
      final cookbookIdsResponse =
          await Supabase.instance.client.from('cookbook_recipes').select('cookbook_id').eq('user_id', userId);

      if (cookbookIdsResponse.isEmpty) {
        return [];
      }

      final List<String> cookbookIds = cookbookIdsResponse.map((row) => row['cookbook_id'] as String).toList();

      final cookbooksResponse =
          await Supabase.instance.client.from('cookbooks').select('*').inFilter('id', cookbookIds).eq('public', true);

      final List<Map<String, dynamic>> cookbooksWithImages = [];

      for (var cookbook in cookbooksResponse) {
        final cookbookId = cookbook['id'] as String;

        final recipesResponse = await Supabase.instance.client
            .from('cookbook_recipes')
            .select('recipes(image_url)')
            .eq('cookbook_id', cookbookId)
            .eq('user_id', userId)
            .limit(3);

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
            ...cookbook,
            'images': images,
            'recipesCount': recipesCountResponse.length,
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

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.left_chevron),
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(8),
            child: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'report',
                  child: Row(
                    children: [
                      Icon(Icons.account_circle_outlined, color: Color.fromARGB(255, 193, 27, 27)),
                      SizedBox(width: 8),
                      Text('Report User', style: TextStyle(color: Color.fromARGB(255, 193, 27, 27))),
                    ],
                  ),
                ),
              ],
              onSelected: (String value) {
                if (value == 'report') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ReportOptionsDialog(userId: widget.profileData['id']);
                    },
                  );
                }
              },
              icon: Icon(Icons.more_vert_outlined),
            ),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 55,
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
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.profileData['bio'] ?? '',
                                style: Theme.of(context).textTheme.bodyMedium,
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
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _recipesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Loader());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final recipes = snapshot.data!;
                  LoggerService.logger.i(recipes.toString());
                  return recipes.isEmpty
                      ? EmptyValue(
                          iconData: Icons.bookmark_outline,
                          description: 'No recipes available',
                        )
                      : Padding(
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
                  return const Center(child: Text('No recipes found.'));
                }
              },
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _cookbooksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching cookbooks'));
                } else if (snapshot.hasData) {
                  final cookbooks = snapshot.data!;
                  if (cookbooks.isEmpty) {
                    return EmptyValue(
                      iconData: Icons.collections_bookmark_outlined,
                      description: 'No cookbooks available',
                    );
                  }
                  LoggerService.logger.i('EXECUTED!!!!!!!!');
                  LoggerService.logger.i(cookbooks);
                  return GridView.builder(
                    padding: EdgeInsets.only(top: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.57,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                    ),
                    itemCount: cookbooks.length,
                    itemBuilder: (context, index) {
                      final cookbook = cookbooks[index];
                      return UserProfileCookbookCard(cookbook: cookbook);
                    },
                  );
                }
                return const Center(child: Text('No cookbooks found.'));
              },
            ),
          ],
        ),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSuccessSnackBar(context, "Report for '$type' has been successfully submitted.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Report',
            style: Theme.of(context).textTheme.titleMedium,
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
          Text(
            'Please select the type of report',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
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
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class UserProfileCookbookCard extends StatelessWidget {
  final Map<String, dynamic> cookbook;

  const UserProfileCookbookCard({required this.cookbook});

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
            builder: (context) => UserCookbookDetails(
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
