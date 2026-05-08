/*
UI ONLY
- blocks background interaction
- closes on outside tap
- prevents inside tap closing
- uses blur and theming
- stack-based overlay
- uses dismissable flag
- avoids edge-case tap handling bugs
*/

import 'dart:ui';
import 'package:flutter/material.dart';

class AppModal extends StatelessWidget {
  const AppModal({
    super.key,
    required this.child,
    this.maxWidth = 520,
    this.padding = const EdgeInsets.all(16),
    this.dismissible = true,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;
  final bool dismissible;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: dismissible ? () => Navigator.pop(context) : null,
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
        ),

        // Modal content
        Center(
          child: GestureDetector(
            onTap: () {}, // prevent close
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  margin: padding,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}