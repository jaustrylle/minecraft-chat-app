import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

/// =========================
/// MODEL
/// =========================
class ChatMessage {
  final String id;
  final String userId;
  final String image;
  final String? text;
  final DateTime? timestamp;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.image,
    this.text,
    this.timestamp,
  });
}

/// =========================
/// SIMPLE IN-MEMORY CACHE
/// =========================
class UserCache {
  static final Map<String, Map<String, dynamic>> _cache = {};

  static Map<String, dynamic>? get(String id) => _cache[id];

  static void set(String id, Map<String, dynamic> data) {
    _cache[id] = data;
  }
}

/// =========================
/// IMAGE DETAILS PAGE
/// =========================
class ImageDetailsWidget extends StatefulWidget {
  const ImageDetailsWidget({
    super.key,
    required this.chatMessage,
  });

  final ChatMessage chatMessage;

  @override
  State<ImageDetailsWidget> createState() => _ImageDetailsWidgetState();
}

class _ImageDetailsWidgetState extends State<ImageDetailsWidget> {
  final supabase = Supabase.instance.client;

  late Future<Map<String, dynamic>?> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = _getUser();
  }

  Future<Map<String, dynamic>?> _getUser() async {
    final cached = UserCache.get(widget.chatMessage.userId);
    if (cached != null) return cached;

    try {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', widget.chatMessage.userId)
          .maybeSingle();

      if (data != null) {
        UserCache.set(widget.chatMessage.userId, data);
      }

      return data;
    } catch (e) {
      debugPrint('User fetch error: $e');
      return null;
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    return DateFormat.jm().format(time);
  }

  @override
  Widget build(BuildContext context) {
    final msg = widget.chatMessage;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// ================= IMAGE =================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Hero(
                  tag: msg.id, // FIXED: stable + unique

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),

                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,

                      child: CachedNetworkImage(
                        imageUrl: msg.image,
                        width: double.infinity,
                        fit: BoxFit.contain,

                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),

                        errorWidget: (context, url, error) =>
                            const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fade(duration: 250.ms)
                    .scale(begin: const Offset(0.97, 0.97)),
              ),
            ),

            /// ================= USER INFO =================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),

              child: FutureBuilder<Map<String, dynamic>?>(
                future: userFuture,

                builder: (context, snapshot) {
                  final user = snapshot.data;

                  final displayName =
                      user?['display_name'] ?? 'Unknown User';

                  final avatarUrl =
                      user?['photo_url']; // FIXED schema

                  final timeText = _formatTime(msg.timestamp);

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// AVATAR
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.shade800,

                        backgroundImage: (avatarUrl != null &&
                                avatarUrl.toString().isNotEmpty)
                            ? CachedNetworkImageProvider(avatarUrl)
                            : null,

                        child: (avatarUrl == null ||
                                avatarUrl.toString().isEmpty)
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),

                      const SizedBox(width: 12),

                      /// NAME + TEXT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// NAME + TIME
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    displayName,
                                    style: GoogleFonts.figtree(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                Text(
                                  timeText,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            /// OPTIONAL TEXT
                            if (msg.text != null &&
                                msg.text!.trim().isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                msg.text!,
                                style: GoogleFonts.figtree(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: 0.1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}