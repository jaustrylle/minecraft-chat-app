// lib/components/app_footer.dart

import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),

      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.green.shade800, width: 2),
        ),
      ),

      child: Column(
        children: [
          const Text(
            "Minecraft Game Guide",
            style: TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Created for educational purposes • Spring 2026",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          const Text(
            "Not affiliated with Mojang or Minecraft",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          /// OPTIONAL NAV LINKS
          Wrap(
            spacing: 10,
            children: [
              footerLink(context, "Home", "/"),
              footerLink(context, "Crafting", "/crafting"),
              footerLink(context, "Knowledge", "/knowledge"),
              footerLink(context, "Chats", "/chats"),
              footerLink(context, "About", "/about"),
            ],
          ),
        ],
      ),
    );
  }

  Widget footerLink(BuildContext context, String text, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.greenAccent,
          decoration: TextDecoration.underline,
          fontSize: 12,
        ),
      ),
    );
  }
}