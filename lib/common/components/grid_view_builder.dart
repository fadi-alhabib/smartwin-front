import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GridViewBuilder extends HookWidget {
  const GridViewBuilder(
      {super.key,
      required this.itemBuilder,
      required this.crossAxisCount,
      required this.itemCount,
      this.childAspectRatio = 1.0});
  final Widget? Function(BuildContext, int) itemBuilder;
  final int crossAxisCount;
  final int itemCount;
  final double childAspectRatio;
  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 17,
              mainAxisSpacing: 17),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: itemCount,
          itemBuilder: itemBuilder),
    );
  }
}
