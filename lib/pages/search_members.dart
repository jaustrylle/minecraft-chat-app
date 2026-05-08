import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class SearchMembersPage extends StatefulWidget {
  const SearchMembersPage({super.key});

  @override
  State<SearchMembersPage> createState() => _SearchMembersPageState();
}

class _SearchMembersPageState extends State<SearchMembersPage> {
  final supabase = Supabase.instance.client;

  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> _results = [];
  bool _loading = false;

  Timer? _debounce;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchUsers(value);
    });
  }

  Future<void> _searchUsers(String query) async {
    final currentUser = supabase.auth.currentUser;

    if (query.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await supabase
          .from('users')
          .select()
          .ilike('display_name', '%$query%')
          .limit(20);

      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response);

      // exclude current user
      final filtered = data.where((user) {
        return user['id'] != currentUser?.id;
      }).toList();

      setState(() {
        _results = filtered;
      });
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _openProfile(String userId) {
    context.go('/user/$userId');
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Members"),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          if (_loading) const LinearProgressIndicator(),

          Expanded(
            child: _results.isEmpty
                ? const Center(
                    child: Text("No users found"),
                  )
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final user = _results[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: (user['avatar_url'] != null &&
                                  user['avatar_url'].toString().isNotEmpty)
                              ? NetworkImage(user['avatar_url'])
                              : null,
                          child: (user['avatar_url'] == null ||
                                  user['avatar_url'].toString().isEmpty)
                              ? const Icon(Icons.person)
                              : null,
                        ),

                        title: Text(
                          user['display_name'] ?? 'Unknown',
                          style: GoogleFonts.figtree(),
                        ),

                        subtitle: Text(user['email'] ?? ''),

                        onTap: () => _openProfile(user['id']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}