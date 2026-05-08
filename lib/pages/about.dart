import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.greenAccent,
        ),
      ),
    );
  }

  Widget paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: const Color(0xFF1a1a1a),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.png"),
            fit: BoxFit.cover,
            alignment: Alignment(0, 0.6),
            opacity: 0.25,
          ),
        ),

        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              constraints: const BoxConstraints(maxWidth: 800),

              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.greenAccent.withValues(alpha: 0.4),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About Us",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),

                  const SizedBox(height: 10),

                  paragraph(
                    "The Minecraft Game Guide is your comprehensive resource for all things Minecraft.",
                  ),
                  paragraph(
                    "Whether you're a beginner or experienced player, we help you improve your gameplay.",
                  ),
                  paragraph(
                    "We include crafting recipes, mob info, biome guides, and more.",
                  ),

                  sectionTitle("Our Goal"),
                  paragraph(
                    "We are building a companion app for Minecraft players with tips, tricks, and structured guidance.",
                  ),

                  sectionTitle("Developers"),
                  paragraph(
                    "Built as a CS Software Engineering project (Spring 2026) by Margarita Torres Fabela, Tae Heon Lim, Serena Reese, Angela Knox, and Joseph Breeden.",
                  ),

                  sectionTitle("Disclaimer"),
                  paragraph(
                    "Minecraft is owned by Mojang/Microsoft. This app is a fan-made educational companion.",
                  ),
                  paragraph(
                    "All external references belong to their respective owners.",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}