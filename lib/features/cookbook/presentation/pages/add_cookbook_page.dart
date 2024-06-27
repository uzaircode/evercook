import 'package:evercook/features/cookbook/presentation/pages/add_multiple_recipe_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCookbookPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => AddCookbookPage());
  const AddCookbookPage({super.key});

  @override
  State<AddCookbookPage> createState() => _AddCookbookPageState();
}

class _AddCookbookPageState extends State<AddCookbookPage> {
  final TextEditingController titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? public = true;

  void navigateToAddRecipes() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddMultipleRecipePage(
            title: titleController.text,
            public: public!,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(
              CupertinoIcons.left_chevron,
            ),
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              navigateToAddRecipes();
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 221, 56, 32),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name of the cookbook',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                maxLines: null,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cookbook name cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 26),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sharing Option',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsetsDirectional.zero,
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Public',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: ' - Visible to everyone',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      leading: Radio<bool>(
                        value: true,
                        groupValue: public,
                        activeColor: Color.fromARGB(255, 221, 56, 32),
                        onChanged: (bool? value) {
                          setState(() {
                            public = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsetsDirectional.zero,
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Private',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: ' - Not visible to others',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      leading: Radio<bool>(
                        value: false,
                        groupValue: public,
                        activeColor: Color.fromARGB(255, 221, 56, 32),
                        onChanged: (bool? value) {
                          setState(() {
                            public = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
