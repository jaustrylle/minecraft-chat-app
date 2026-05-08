/*
Controls how users move between feed, chat, and profile
Core app shell

Fixes:
1. Navigation is now controlled externally -> parent screen now 
decides which page to show, how routing works, and whether
Navigator or IndexedStack is used
-> this allows for clean routing control, independent feed/chat/profile,
and better scalability (switchable to Navigator 2.0, GoRouter, or IndexedStack tabs)
*/

import 'package:flutter/material.dart';

class SideNavWidget extends StatefulWidget {
  const SideNavWidget({
    super.key,
    required this.selectedNav,
    required this.onSelect,
  });

  final int selectedNav;
  final Function(int index) onSelect;

  @override
  State<SideNavWidget> createState() => _SideNavWidgetState();
}

class _SideNavWidgetState extends State<SideNavWidget> {
  bool hover1 = false;
  bool hover2 = false;
  bool hover3 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          Icon(
            Icons.alternate_email_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 40,
          ),

          const SizedBox(height: 12),

          Divider(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
          ),

          const SizedBox(height: 16),

          _navItem(
            icon: Icons.home_outlined,
            index: 1,
            isHovered: hover1,
            onHover: (v) => setState(() => hover1 = v),
          ),

          const SizedBox(height: 16),

          _navItem(
            icon: Icons.chat_bubble_outline,
            index: 2,
            isHovered: hover2,
            onHover: (v) => setState(() => hover2 = v),
          ),

          const SizedBox(height: 16),

          _navItem(
            icon: Icons.person_outline,
            index: 3,
            isHovered: hover3,
            onHover: (v) => setState(() => hover3 = v),
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required int index,
    required bool isHovered,
    required Function(bool) onHover,
  }) {
    final isSelected = widget.selectedNav == index;

    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: () => widget.onSelect(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(0.2)
                : isHovered
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}