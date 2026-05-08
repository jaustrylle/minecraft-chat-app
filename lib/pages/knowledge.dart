import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/minecraft_table.dart';

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({
    super.key,
    this.initialSearch,
  });

  final String? initialSearch;

  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  bool isTableVisible = false;
  String searchQuery = "";

  bool _didInitFromRoute = false;

  @override
  void initState() {
    super.initState();

    final initial = widget.initialSearch?.trim() ?? "";

    if (initial.isNotEmpty) {
      searchQuery = initial;
      isTableVisible = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Only run ONCE per lifecycle to avoid rebuild loops
    if (_didInitFromRoute) return;

    final query =
        GoRouterState.of(context).uri.queryParameters['query']
            ?.trim();

    if (query != null && query.isNotEmpty) {
      setState(() {
        searchQuery = query;
        isTableVisible = true;
      });
    }

    _didInitFromRoute = true;
  }

  void _toggleTable() {
    setState(() {
      isTableVisible = !isTableVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = searchQuery.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Knowledge Base"),
        backgroundColor: Colors.black,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.png"),
            fit: BoxFit.cover,
            alignment: Alignment(0, -0.2),
          ),
        ),

        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 20,
              ),

              padding: const EdgeInsets.all(20),

              constraints: const BoxConstraints(maxWidth: 900),

              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                children: [
                  /// SEARCH LABEL
                  if (normalizedQuery.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Results for: $normalizedQuery",
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                        ),
                      ),
                    ),

                  const Text(
                    "Minecraft Knowledge Base",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Access comprehensive data regarding items, armor, and blocks within the game.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// TOGGLE BUTTON
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isTableVisible ? Colors.red : Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),

                    onPressed: _toggleTable,

                    child: Text(
                      isTableVisible
                          ? "HIDE DATA TABLE"
                          : "VIEW FULL KNOWLEDGE TABLE",
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// TABLE
                  if (isTableVisible)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MinecraftTable(
                        searchQuery: normalizedQuery,
                      ),
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