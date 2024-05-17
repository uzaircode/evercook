import 'package:evercook/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      );
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Save',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const CircleAvatar(
                      radius: 80,
                      backgroundColor: AppPallete.gradient3,
                      child: Center(
                        child: Text(
                          'No Image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Username',
                    ),
                    validator: (value) {
                      return value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Bio',
                    ),
                    validator: (value) {
                      return value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
