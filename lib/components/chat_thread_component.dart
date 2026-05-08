import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatThreadComponentWidget extends StatefulWidget {
  const ChatThreadComponentWidget({
    super.key,
    required this.conversationId,
  });

  final String conversationId;

  @override
  State<ChatThreadComponentWidget> createState() =>
      _ChatThreadComponentWidgetState();
}

class _ChatThreadComponentWidgetState
    extends State<ChatThreadComponentWidget> {
  final supabase = Supabase.instance.client;
  final TextEditingController textController = TextEditingController();

  late final String currentUserId;

  List<Map<String, dynamic>> messages = [];
  RealtimeChannel? channel;

  @override
  void initState() {
    super.initState();

    currentUserId = supabase.auth.currentUser!.id;

    loadMessages();
    subscribeToMessages();
  }

  /// ================= LOAD MESSAGES =================
  Future<void> loadMessages() async {
    final data = await supabase
        .from('messages')
        .select()
        .eq('conversation_id', widget.conversationId)
        .order('created_at');

    setState(() {
      messages = List<Map<String, dynamic>>.from(data);
    });
  }

  /// ================= SEND MESSAGE =================
  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final response = await supabase
        .from('messages')
        .insert({
          'conversation_id': widget.conversationId,
          'sender_id': currentUserId,
          'content': text,
          'message_type': 'text',
        })
        .select()
        .single();

    /// optimistic update (instant UI)
    setState(() {
      messages.add(response);
    });

    await supabase.from('conversations').update({
      'last_message': text,
      'last_message_at': DateTime.now().toIso8601String(),
    }).eq('id', widget.conversationId);

    textController.clear();
  }

  /// ================= REALTIME =================
  void subscribeToMessages() {
    channel = supabase
        .channel('conversation_${widget.conversationId}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: widget.conversationId,
          ),
          callback: (payload) {
            final newMessage =
                Map<String, dynamic>.from(payload.newRecord);

            if (!mounted) return;

            setState(() {
              final exists = messages.any(
                (m) => m['id'] == newMessage['id'],
              );

              if (!exists) {
                messages.add(newMessage);
              }
            });
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    channel?.unsubscribe();
    textController.dispose();
    super.dispose();
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// MESSAGES
        Expanded(
          child: messages.isEmpty
              ? const Center(child: Text("No messages yet"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];

                    final isMe =
                        msg['sender_id'] == currentUserId;

                    final type =
                        msg['message_type'] ?? 'text';

                    final content =
                        msg['content'] ?? '';

                    final mediaUrl =
                        msg['media_url'];

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.blue
                              : Colors.grey.shade300,
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: _buildMessage(type, content, mediaUrl),
                      ),
                    );
                  },
                ),
        ),

        /// INPUT
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ================= MESSAGE TYPES =================
  Widget _buildMessage(
    String type,
    String content,
    dynamic mediaUrl,
  ) {
    switch (type) {
      case 'image':
        if (mediaUrl == null) return const Text("Image missing");

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            mediaUrl,
            width: 200,
            fit: BoxFit.cover,
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
                style: const TextStyle(fontSize: 10),
              ),
          ],
        );

      case 'text':
      default:
        return Text(content);
    }
  }
}