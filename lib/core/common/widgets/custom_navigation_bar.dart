import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final String largeTitle;
  final String middleTitle;
  final Widget? leading;
  final Widget? trailing;
  final Object? heroTag;

  const CustomNavigationBar({
    Key? key,
    required this.largeTitle,
    required this.middleTitle,
    this.leading,
    this.trailing,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      border: Border(),
      heroTag: heroTag ?? '',
      alwaysShowMiddle: false,
      largeTitle: Text(
        largeTitle,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      middle: Text(
        middleTitle,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      leading: leading,
      trailing: trailing,
    );
  }
}
