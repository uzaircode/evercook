import 'package:evercook/core/common/pages/home/dashboard.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CookbookEditPage extends StatefulWidget {
  static route(String cookbookId) => MaterialPageRoute(
        builder: (context) => CookbookEditPage(cookbookId: cookbookId),
      );

  final String cookbookId;

  const CookbookEditPage({Key? key, required this.cookbookId}) : super(key: key);

  @override
  State<CookbookEditPage> createState() => _CookbookEditPageState();
}

class _CookbookEditPageState extends State<CookbookEditPage> {
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoggerService.logger.d('The cookbook id is : ${widget.cookbookId}');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Cookbook',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Supabase.instance.client
                  .from('cookbooks')
                  .update({'title': nameController.text}).match({'id': widget.cookbookId});

              Navigator.pushAndRemoveUntil(
                context,
                Dashboard.route(),
                (route) => false,
              );
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Color.fromARGB(255, 221, 56, 32),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () async {
                await Supabase.instance.client.from('cookbooks').delete().match({'id': widget.cookbookId});
                Navigator.pushAndRemoveUntil(
                  context,
                  Dashboard.route(),
                  (route) => false,
                );
              },
              child: Text(
                'Delete Cookbook',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 221, 56, 32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
