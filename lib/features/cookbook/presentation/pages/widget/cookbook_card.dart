import 'package:evercook/core/utils/logger.dart';
import 'package:evercook/features/cookbook/presentation/pages/cookbook_recipe_details.dart';
import 'package:flutter/material.dart';

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
            builder: (context) => CookbookDetailsPage(
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
