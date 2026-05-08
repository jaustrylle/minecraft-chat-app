/*
FIXES implemented:
1. prevent null crashes from missing users
2. fallback between text and content added
3. safe UI rendering

FUTURE UPGRADES:
1. multiple independent "mini schemas" are here per feature,
we need to standardize ALL content models by unifying
posts, stories, comments, and chat messages
into this format:
user_id
content
media_url (optional)
created_at
2. THEN refactor:
postComments
storyComments
userPosts
userStories
INTO CONSISTENT SCHEMA
*/

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommentBubbleWidget extends StatelessWidget {
  const CommentBubbleWidget({
    super.key,
    required this.comment,
    required this.currentUserId,
  });

  final Map<String, dynamic> comment;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final isMe = comment['user_id'] == currentUserId;

    final user = comment['users'] ?? {};

    final content = comment['content'] ?? comment['text'] ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          /// USER ROW (safe optional join)
          if (user.isNotEmpty)
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isMe && (user['photo_url'] ?? '').isNotEmpty)
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      user['photo_url'],
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  user['display_name'] ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

          const SizedBox(height: 6),

          /// COMMENT TEXT
          Text(content),
        ],
      ),
    );
  }
}