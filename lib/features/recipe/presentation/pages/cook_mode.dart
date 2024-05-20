import 'package:evercook/core/common/widgets/empty_value.dart';
import 'package:evercook/features/recipe/domain/entities/recipe.dart';
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
            color: Colors.grey[300],
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
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () {
                _showFontSizeOptions(context);
              },
              icon: const Icon(Icons.format_size_outlined),
              color: const Color.fromARGB(255, 96, 94, 94),
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
                        style: TextStyle(
                          fontSize: _fontSize,
                          color: Color.fromARGB(255, 69, 67, 67),
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
                      children: ingredients.map((ingredient) {
                        String name = ingredient['name'];
                        List<InlineSpan> spans = [];
                        RegExp exp = RegExp(r'(\d*\.?\d+)|(\D+)');
                        exp.allMatches(name).forEach((match) {
                          if (match.group(1) != null) {
                            spans.add(TextSpan(
                              text: match.group(1),
                              style: TextStyle(
                                color: const Color.fromARGB(255, 244, 118, 160),
                                fontSize: _fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ));
                          }
                          if (match.group(2) != null) {
                            spans.add(TextSpan(
                              text: match.group(2),
                              style: TextStyle(
                                fontSize: _fontSize,
                                color: Color.fromARGB(255, 69, 67, 67),
                                fontWeight: FontWeight.w600,
                              ), // Style for the rest of the text
                            ));
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
      backgroundColor: Colors.white,
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
                    color: Colors.grey[300],
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
                    color: Color.fromARGB(255, 127, 127, 127),
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

  Widget _buildFontSizeOption(BuildContext context, double fontSize, String label) {
    final bool isSelected = _fontSize == fontSize;

    return RadioListTile<double>(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? Colors.black : Color.fromARGB(255, 96, 94, 94),
        ), // Customize font style
      ),
      value: fontSize,
      groupValue: _fontSize,
      onChanged: (double? value) {
        setState(() {
          _fontSize = value ?? 20; // Default to 20 if value is null
        });
        Navigator.pop(context);
      },
      activeColor: const Color.fromARGB(255, 244, 118, 160),
      controlAffinity: ListTileControlAffinity.trailing, // Move the radio button to the right
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20), // Adjust padding
    );
  }
}
