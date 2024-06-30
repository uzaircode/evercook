import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class CookModePage extends StatefulWidget {
  static route(Recipe recipe) => MaterialPageRoute(builder: (context) => CookModePage(recipe: recipe));
  final Recipe recipe;

  const CookModePage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<CookModePage> createState() => _CookModePageState();
}

class _CookModePageState extends State<CookModePage> {
  double _fontSize = 24;

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    final directions = widget.recipe.directions ?? '';
    final ingredients = widget.recipe.ingredients;

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () async {
              await Wakelock.disable();
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.left_chevron,
            ),
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () {
                _showFontSizeOptions(context);
              },
              icon: const Icon(Icons.format_size_outlined),
              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ),
        ],
      ),
      body: directions.isEmpty
          ? EmptyValue(
              iconData: Icons.question_mark_sharp,
              description: 'No directions in',
              value: 'Cook Mode',
            )
          : PageView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 40.0),
                  child: Column(
                    children: [
                      Text(
                        directions,
                        // style: TextStyle(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: _fontSize,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 40.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: ingredients!.map((ingredient) {
                        String name = ingredient;
                        List<InlineSpan> spans = [];
                        RegExp exp = RegExp(r'(\b\d*\.?\d+\s*(?:/\s*\d+)?|¼|½|¾|\d+/\d+)|(\D+)');
                        exp.allMatches(name).forEach((match) {
                          if (match.group(1) != null) {
                            spans.add(TextSpan(
                              text: match.group(1),
                              style: TextStyle(
                                color: const Color.fromARGB(255, 221, 56, 32),
                                fontSize: _fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ));
                          }
                          if (match.group(2) != null) {
                            spans.add(
                              TextSpan(
                                text: match.group(2),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: _fontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            );
                          }
                        });

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: RichText(
                            text: TextSpan(
                              children: spans,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showFontSizeOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Theme.of(context).brightness == Brightness.light
                        ? Color.fromARGB(255, 226, 227, 227)
                        : Color(0xFF3F3F3F),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Cook Mode Font Size',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              SizedBox(height: 8),
              _buildFontSizeOption(context, 20, 'Small'),
              _buildFontSizeOption(context, 24, 'Medium'),
              _buildFontSizeOption(context, 26, 'Large'),
            ],
          ),
        );
      },
    );
  }

  //todo move this widget to widget page
  Widget _buildFontSizeOption(BuildContext context, double fontSize, String label) {
    final bool isSelected = _fontSize == fontSize;

    return RadioListTile<double>(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? Theme.of(context).colorScheme.onBackground : Color.fromARGB(255, 96, 94, 94),
        ),
      ),
      value: fontSize,
      groupValue: _fontSize,
      onChanged: (double? value) {
        setState(() {
          _fontSize = value ?? 20;
        });
        Navigator.pop(context);
      },
      activeColor: Color.fromARGB(255, 221, 56, 32),
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    );
  }
}
