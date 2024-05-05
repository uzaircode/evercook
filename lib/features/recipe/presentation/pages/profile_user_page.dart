import 'package:evercook/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileUserPage extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const ProfileUserPage({Key? key, required this.profileData}) : super(key: key);

  static route(Map<String, dynamic> profileData) =>
      MaterialPageRoute(builder: (context) => ProfileUserPage(profileData: profileData));

  @override
  _ProfileUserPageState createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  late Future<List<Map<String, dynamic>>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = fetchRecipesByUserId(widget.profileData['id']);
  }

  Future<List<Map<String, dynamic>>> fetchRecipesByUserId(String userId) async {
    final response = await Supabase.instance.client.from('recipes').select().eq('user_id', userId);

    LoggerService.logger.i('data of recipes of this particular user: $response');
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profileData['name']),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.report),
            onPressed: () {
              // Add action for editing profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.profileData['name'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.profileData['imageUrl'] ?? 'https://via.placeholder.com/150'),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _recipesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final recipes = snapshot.data!;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return ListTile(
                        title: Text(recipe['title']),
                        subtitle: Text(recipe['description']),
                        onTap: () {
                          // Handle recipe tap
                        },
                      );
                    },
                  );
                } else {
                  return const Text('No recipes found.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
