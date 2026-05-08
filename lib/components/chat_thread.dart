import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatThreadWidget extends StatelessWidget {
  const ChatThreadWidget({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  final Map<String, dynamic> message;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final senderId = message['sender_id']?.toString() ?? '';
    final isMe = senderId == currentUserId;

    final type = message['message_type']?.toString() ?? 'text';
    final content = message['content']?.toString() ?? '';
    final mediaUrl = message['media_url']?.toString();

    /// SAFE USER PARSE (handles null, map, or malformed join)
    final userRaw = message['users'];
    final Map<String, dynamic> user =
        (userRaw is Map<String, dynamic>) ? userRaw : {};

    final displayName = user['display_name']?.toString() ?? 'Unknown';
    final photoUrl = user['photo_url']?.toString();

    final createdAt = message['created_at']?.toString();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// AVATAR (left side only)
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                  ? CachedNetworkImageProvider(photoUrl)
                  : null,
              child: (photoUrl == null || photoUrl.isEmpty)
                  ? const Icon(Icons.person, size: 16)
                  : null,
            ),

          const SizedBox(width: 8),

          /// MESSAGE BUBBLE
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue.shade200 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  /// USER NAME (optional)
                  if (displayName.isNotEmpty && !isMe)
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),

                  const SizedBox(height: 4),

                  /// MESSAGE CONTENT
                  _buildMessage(type, content, mediaUrl),

                  const SizedBox(height: 6),

                  /// TIMESTAMP (safe)
                  if (createdAt != null)
                    Text(
                      createdAt,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String type, String content, String? mediaUrl) {
    switch (type) {
      case 'image':
        if (mediaUrl == null || mediaUrl.isEmpty) {
          return const Text("Image unavailable");
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: mediaUrl,
            width: 220,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image),
          ),
        );

      case 'video':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.videocam),
            const SizedBox(height: 4),
            Text(content),
            if (mediaUrl != null)
              Text(
                mediaUrl,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
          ],
        );

      case 'text':
      default:
        return Text(
          content,
          style: const TextStyle(fontSize: 14),
        );
    }
  }
}