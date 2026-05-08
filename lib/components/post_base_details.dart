/*
- no empty string image crashes
- safe fallback avatar
- supports missing joins
- backward compatible with old fields during migration

Post system can now support images, videos (later via media_type),
and multiple formats

To fully stabilize our app, we need to unify post schema to match the
chat systems:
user_id
content
media_url
created_at

-> this will allow:
posts = "public messages"
comments = messages on posts
components = reusable
*/

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostDetailsBaseWidget extends StatelessWidget {
  const PostDetailsBaseWidget({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
  });

  final Map<String, dynamic> post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;

  @override
  Widget build(BuildContext context) {
    final user = post['users'] ?? {};

    final content = post['content'] ?? post['caption'] ?? '';
    final mediaUrl = post['media_url'] ?? post['image'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// USER HEADER (safe optional join)
          ListTile(
            leading: (user['photo_url'] ?? '').isNotEmpty
                ? CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      user['photo_url'],
                    ),
                  )
                : const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
            title: Text(user['display_name'] ?? 'Unknown'),
            subtitle: Text(
              post['created_at']?.toString() ?? '',
            ),
          ),

          /// MEDIA
          if (mediaUrl != null && mediaUrl.toString().isNotEmpty)
            CachedNetworkImage(
              imageUrl: mediaUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),

          const SizedBox(height: 12),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          const SizedBox(height: 12),

          /// ACTIONS
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: onLike,
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: onComment,
              ),
            ],
          ),
        ],
      ),
    );
  }
}