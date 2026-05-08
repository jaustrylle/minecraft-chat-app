/*
Usable for chat loading (convo avatars), user lists (search results),
and feed headers (profile row loading)
*/

import 'package:flutter/material.dart';

class HorizontalSkeletonLoader extends StatelessWidget {
  const HorizontalSkeletonLoader({
    super.key,
    this.count = 5,
    this.size = 50,
    this.spacing = 12,
    this.shape = BoxShape.circle,
  });

  final int count;
  final double size;
  final double spacing;
  final BoxShape shape;

  Widget _skeletonItem(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: shape,
        color: Colors.grey.shade300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(count, (i) {
          return Padding(
            padding: EdgeInsets.only(
              right: i == count - 1 ? 0 : spacing,
            ),
            child: _skeletonItem(size),
          );
        }),
      ),
    );
  }
}