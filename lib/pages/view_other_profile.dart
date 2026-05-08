import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewOtherProfilePage extends StatefulWidget {
  final String userId;

  const ViewOtherProfilePage({
    super.key,
    required this.userId,
  });

  @override
  State<ViewOtherProfilePage> createState() =>
      _ViewOtherProfilePageState();
}

class _ViewOtherProfilePageState extends State<ViewOtherProfilePage> {
  final supabase = Supabase.instance.client;

  Map<String, dynamic>? profile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() => loading = true);

    try {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', widget.userId)
          .maybeSingle();

      if (!mounted) return;

      setState(() {
        profile = data;
      });
    } catch (e) {
      debugPrint("Error loading profile: $e");
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  /// SAFE FIELD ACCESSOR (prevents runtime crashes)
  String _safeString(dynamic value, String fallback) {
    if (value == null) return fallback;
    final str = value.toString().trim();
    return str.isEmpty ? fallback : str;
  }

  @override
  Widget build(BuildContext context) {
    final displayName =
        _safeString(profile?['display_name'], "No name");

    final bio =
        _safeString(profile?['bio'], "No bio");

    final avatarUrl = profile?['avatar_url'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())

          : profile == null
              ? const Center(child: Text("User not found"))

              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: (avatarUrl != null &&
                                avatarUrl.toString().isNotEmpty)
                            ? CachedNetworkImageProvider(
                                avatarUrl,
                              )
                            : null,
                        child: (avatarUrl == null ||
                                avatarUrl.toString().isEmpty)
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: Text(
                        bio,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Divider(),

                    ListTile(
                      title: const Text("User ID"),
                      subtitle: Text(widget.userId),
                    ),
                  ],
                ),
    );
  }
}