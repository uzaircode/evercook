import 'package:flutter/material.dart';

// ? i dont like this, please rename!!!
class EmptyValue extends StatelessWidget {
  final IconData? iconData;
  final String? description;
  final String? value;

  const EmptyValue({
    Key? key,
    this.iconData,
    this.description,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 36,
            color: Color.fromARGB(255, 211, 211, 211),
          ),
          SizedBox(height: 5),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '$description \n',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 171, 171, 171),
              ),
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    height: 1.3,
                    fontSize: 16,
                    color: Color.fromARGB(255, 127, 127, 127),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
