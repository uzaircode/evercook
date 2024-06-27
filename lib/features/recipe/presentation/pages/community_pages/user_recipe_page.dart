import 'package:cached_network_image/cached_network_image.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserRecipePage extends StatelessWidget {
  static MaterialPageRoute route(Map<String, dynamic> recipe) {
    return MaterialPageRoute(builder: (context) => UserRecipePage(recipe: recipe));
  }

  final Map<String, dynamic> recipe;

  const UserRecipePage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoggerService.logger.d(recipe.toString());
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            pinned: true,
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeaderImage(recipe['image_url'] ?? ''),
            ),
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
                icon: const Icon(
                  CupertinoIcons.left_chevron,
                ),
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildRecipeDetails(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildHeaderImage(String imageUrl) {
    return Hero(
      tag: 'transition',
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        errorWidget: (context, error, stackTrace) {
          return const Center(child: Text('Image not available'));
        },
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildRecipeDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe['name'] ?? '(No name)',
            softWrap: true,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildDetailsRow(
            recipe['prep_time'] ?? '',
            recipe['cook_time'] ?? '',
            recipe['servings'] ?? '',
            context,
          ),
          const SizedBox(height: 24),
          Text(
            recipe['description'] ?? '',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 20),
          Divider(),
          _buildSectionWithContent(
            context,
            'Ingredients',
          ),
          _buildIngredientList(recipe['ingredients'] ?? [], context),
          const SizedBox(height: 20),
          Divider(),
          _buildSectionWithContent(
            context,
            'Directions',
            content: recipe['directions'],
          ),
          const SizedBox(height: 20),
          Divider(),
          _buildSectionWithContent(
            context,
            'Utensils',
            content: recipe['utensils'],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildDetailsRow(
    String? prepTime,
    String? cookTime,
    String? servings,
    BuildContext context,
  ) {
    if ((prepTime == null || prepTime.isEmpty) &&
        (cookTime == null || cookTime.isEmpty) &&
        (servings == null || servings.isEmpty)) {
      return SizedBox.shrink();
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildDetailColumn(
            'Prep',
            context,
            prepTime ?? '',
            icon: Icon(
              Icons.access_time_rounded,
              size: 22,
            ),
            divider: VerticalDivider(
              thickness: 1.2,
            ),
          ),
          _buildDetailColumn(
            'Cook',
            context,
            cookTime ?? '',
            divider: VerticalDivider(
              thickness: 1.2,
            ),
          ),
          _buildDetailColumn(
            'Servings',
            context,
            servings ?? '',
            divider: VerticalDivider(
              thickness: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildDetailColumn(
    String title,
    BuildContext context,
    String value, {
    Widget? icon,
    Widget? divider,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Row(
        children: [
          if (icon != null) icon,
          if (divider != null) divider,
          SizedBox(width: 5),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  //todo move this widget to widget page
  Widget _buildIngredientList(
    List<dynamic> ingredients,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients
          .map((ingredient) => Text(
                ingredient.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
              ))
          .toList(),
    );
  }

  //todo move this widget to widget page
  // Widget _buildSectionTitle(
  //   String? title,
  //   BuildContext context,
  // ) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Text(
  //       title,
  //       style: Theme.of(context).textTheme.titleMedium,
  //     ),
  //   );
}

Widget _buildSectionWithContent(BuildContext context, String title, {String? content}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content != null
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              )
            : SizedBox.shrink(),
      ],
    ),
  );
}
