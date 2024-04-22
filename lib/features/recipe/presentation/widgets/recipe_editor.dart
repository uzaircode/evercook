import 'package:flutter/material.dart';

class RecipeEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? initialValue;
  const RecipeEditor({super.key, required this.controller, required this.hintText, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      initialValue: initialValue,
      maxLines: null,
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
    );
  }
}
