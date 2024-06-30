import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/core/common/widgets/loader.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/recipe/presentation/pages/community_pages/profile_user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomSearch extends SearchDelegate<String> {
  @override
  TextStyle? get searchFieldStyle => TextStyle(
        color: Color.fromARGB(255, 122, 122, 122),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  @override
  String? get searchFieldLabel => 'Search user';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        CupertinoIcons.left_chevron,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchSearchResults(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Loader());
        }

        var results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final profile = results[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                backgroundImage: NetworkImage(profile['avatar_url']),
              ),
              title: Text(
                profile['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(context, ProfileUserPage.route(profile));
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchSearchResults(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Loader());
        }
        if (query.isEmpty) {
          return const EmptyValue(
            iconData: Icons.search_outlined,
            description: "Start searching for people, we'll wait",
          );
        }

        var results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final profile = results[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                backgroundImage: NetworkImage(
                  profile['avatar_url'] ?? 'https://robohash.org/${profile['id']}',
                ),
              ),
              title: Text(
                profile['name'],
                style: const TextStyle(
                  color: Color.fromARGB(255, 122, 122, 122),
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                LoggerService.logger.d(profile);
                Navigator.push(context, ProfileUserPage.route(profile));
              },
            );
          },
        );
      },
    );
  }

  //todo separate to business logic
  Future<List<Map<String, dynamic>>> fetchSearchResults(String query) async {
    final response = await Supabase.instance.client.from(DBConstants.profilesTable).select().textSearch('name', query);

    return (response as List).cast<Map<String, dynamic>>();
  }
}
