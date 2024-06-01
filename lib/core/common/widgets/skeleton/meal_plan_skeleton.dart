import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonMealPlan extends StatelessWidget {
  const SkeletonMealPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      ignoreContainers: true,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        itemCount: 5,
        itemBuilder: (context, index) {
          return CustomListTile(
            leadingWidth: 60,
            leadingHeight: 60,
          );
        },
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final double leadingWidth;
  final double leadingHeight;
  final int titleWords;
  final int subtitleWords;

  const CustomListTile({
    Key? key,
    required this.leadingWidth,
    required this.leadingHeight,
    this.titleWords = 2,
    this.subtitleWords = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Align row children at the start
            children: <Widget>[
              Bone(
                width: leadingWidth,
                height: leadingHeight,
                borderRadius: BorderRadius.circular(8),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Bone.text(words: titleWords),
                    SizedBox(height: 4),
                    Bone.text(words: subtitleWords),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
