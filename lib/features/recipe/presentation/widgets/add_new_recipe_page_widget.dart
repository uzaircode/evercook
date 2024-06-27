import 'package:flutter/material.dart';

Widget buildTextField(
  String title,
  BuildContext context,
  TextEditingController controller, {
  String? Function(String?)? validator,
  int? maxLines,
  String? hintText,
  bool isExpanded = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$title (Optional)',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      SizedBox(height: 10),
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        ),
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        validator: validator,
        maxLines: isExpanded ? null : maxLines,
        minLines: isExpanded ? (maxLines ?? 3) : null,
        keyboardType: isExpanded ? TextInputType.multiline : TextInputType.text,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    ],
  );
}
