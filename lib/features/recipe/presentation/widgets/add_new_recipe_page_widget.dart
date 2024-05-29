import 'package:flutter/material.dart';

Widget buildTextField(
  String title,
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
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
      SizedBox(height: 10),
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
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
