import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PostDetailsPageWidget extends StatefulWidget {
  final String postId;

  const PostDetailsPageWidget({
    super.key,
    required this.postId,
  });

  @override
  State<PostDetailsPageWidget> createState() =>
      _PostDetailsPageWidgetState();
}

class _PostDetailsPageWidgetState extends State<PostDetailsPageWidget> {
  final supabase = Supabase.instance.client;

  Map<String, dynamic>? post;
  Map<String, dynamic>? user;

  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final postData = await supabase
          .from('posts')
          .select()
          .eq('id', widget.postId)
          .maybeSingle();

      if (postData == null) {
        setState(() {
          post = null;
          user = null;
          loading = false;
        });
        return;
      }

      final userFuture = supabase
          .from('users')
          .select()
          .eq('id', postData['user_id'])
          .maybeSingle();

      final results = await Future.wait<dynamic>([
        Future.value(postData),
        userFuture,
      ]);

      if (!mounted) return;

      setState(() {
        post = results[0] as Map<String, dynamic>;
        user = results[1] as Map<String, dynamic>?;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = "Failed to load post";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Post"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!));
    }

    if (post == null) {
      return const Center(child: Text("Post not found"));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildUserRow(),

          const SizedBox(height: 20),

          Text(
            post?['content'] ?? '',
            style: GoogleFonts.figtree(fontSize: 16),
          ),

          const SizedBox(height: 20),

          if ((post?['image_url'] ?? '').toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(post!['image_url']),
            ),
        ],
      ),
    );
  }

  Widget _buildUserRow() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage:
              (user?['avatar_url'] ?? '').toString().isNotEmpty
                  ? NetworkImage(user!['avatar_url'])
                  : null,
          child: (user?['avatar_url'] ?? '').toString().isEmpty
              ? const Icon(Icons.person)
              : null,
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?['display_name'] ?? 'Unknown',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user?['email'] ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}