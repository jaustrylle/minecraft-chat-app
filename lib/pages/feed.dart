import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/app_header.dart';
import '../components/app_footer.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final supabase = Supabase.instance.client;

  final searchController = TextEditingController();

  late final Stream<List<Map<String, dynamic>>> feedStream;

  @override
  void initState() {
    super.initState();

    feedStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  void handleSearch() {
    final q = searchController.text.trim();
    if (q.isEmpty) return;

    context.push('/knowledge?query=${Uri.encodeComponent(q)}');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Column(
        children: [
          const AppHeader(),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg1.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment(0, -0.05),
                ),
              ),

              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    constraints: const BoxConstraints(maxWidth: 1000),

                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.green.shade900,
                        width: 1,
                      ),
                    ),

                    child: Column(
                      children: [
                        /// ================= SEARCH + NAV =================
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => context.push('/crafting'),
                              child: const Text("Crafting Simulator"),
                            ),

                            SizedBox(
                              width: 260,
                              child: TextField(
                                controller: searchController,
                                onSubmitted: (_) => handleSearch(),
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Search knowledge...",
                                  filled: true,
                                  fillColor: Colors.black87,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),

                            ElevatedButton(
                              onPressed: handleSearch,
                              child: const Text("Search"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () => context.push('/knowledge'),
                          child: const Text("Knowledge Base"),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "Welcome to Minecraft Game Guide",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// ================= MENU GRID =================
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _menu("Public Chats", '/chats'),
                            _menu("Knowledge", '/knowledge'),
                            _menu("Crafting", '/crafting'),
                            _menu("About", '/about'),
                            _menu("Profile", '/profile'),
                          ],
                        ),

                        const SizedBox(height: 30),

                        /// ================= FEED =================
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: feedStream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }

                            final messages = snapshot.data!;

                            if (messages.isEmpty) {
                              return const Text(
                                "No activity yet",
                                style: TextStyle(color: Colors.white70),
                              );
                            }

                            return Column(
                              children: messages.map((msg) {
                                final text = msg['text'];
                                final image = msg['image_url'];
                                final user = msg['display_name'];

                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1e1e1e),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user ?? "Unknown",
                                        style: GoogleFonts.figtree(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (text != null)
                                        Text(
                                          text,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      if (image != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: CachedNetworkImage(
                                            imageUrl: image,
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const AppFooter(),
        ],
      ),
    );
  }

  Widget _menu(String title, String route) {
    return ElevatedButton(
      onPressed: () => context.push(route),
      child: Text(title, textAlign: TextAlign.center),
    );
  }
}