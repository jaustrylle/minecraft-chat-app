/*
UI UTILITY COMPONENT
- uses Material theme
- reusable across chat/feed/profile
- works with Supabase-driven empty states
*/

import 'package:flutter/material.dart';

class EmptyStateSimpleWidget extends StatelessWidget {
  const EmptyStateSimpleWidget({
    super.key,
    this.icon,
    this.title = 'No Data',
    this.body = 'Nothing to display right now.',
  });

  final Widget? icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon ??
                Icon(
                  Icons.inbox_outlined,
                  size: 72,
                  color: colorScheme.primary,
                ),

            const SizedBox(height: 16),

            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 8),

            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}