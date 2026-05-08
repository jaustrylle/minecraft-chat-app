import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class MainProfileWidget extends StatefulWidget {
  const MainProfileWidget({super.key});

  @override
  State<MainProfileWidget> createState() =>
      _MainProfileWidgetState();
}

class _MainProfileWidgetState extends State<MainProfileWidget> {
  final supabase = Supabase.instance.client;

  Map<String, dynamic>? profile;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      if (!mounted) return;
      setState(() {
        profile = null;
        loading = false;
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;

      setState(() {
        profile = data;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = "Failed to load profile";
      });
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProfile,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/edit-settings'),
          ),
        ],
      ),

      body: _buildBody(user),
    );
  }

  Widget _buildBody(User? user) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!));
    }

    if (user == null) {
      return const Center(child: Text("Not logged in"));
    }

    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(child: _avatar()),

          const SizedBox(height: 20),

          Center(
            child: Text(
              profile?['display_name'] ?? "No name set",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Text(
              profile?['bio'] ?? "No bio yet",
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),
          const Divider(),

          ListTile(
            title: const Text("User ID"),
            subtitle: Text(user.id),
          ),

          ListTile(
            title: const Text("Edit Profile"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.go('/edit-profile'),
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    final url = profile?['avatar_url'];

    return CircleAvatar(
      radius: 50,
      backgroundImage: (url != null && url.toString().isNotEmpty)
          ? CachedNetworkImageProvider(url)
          : null,
      child: (url == null || url.toString().isEmpty)
          ? const Icon(Icons.person, size: 50)
          : null,
    );
  }
}