import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Chat2DetailsWidget extends StatefulWidget {
  final String? conversationId;
  final bool isPublicChat;

  const Chat2DetailsWidget({
    super.key,
    this.conversationId,
    this.isPublicChat = false,
  });

  @override
  State<Chat2DetailsWidget> createState() => _Chat2DetailsWidgetState();
}

class _Chat2DetailsWidgetState extends State<Chat2DetailsWidget> {
  final supabase = Supabase.instance.client;

  late Future<List<Map<String, dynamic>>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = _loadMessages();
  }

  Future<List<Map<String, dynamic>>> _loadMessages() async {
    try {
      var query = supabase.from('messages').select();

      if (widget.isPublicChat) {
        query = query.isFilter('conversation_id', null);
      } else {
        if (widget.conversationId == null) {
          throw Exception("Missing conversation ID");
        }

        query = query.eq('conversation_id', widget.conversationId!);
      }

      final res = await query.order('created_at');

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      throw Exception("Failed to load messages: $e");
    }
  }

  @override
  void didUpdateWidget(covariant Chat2DetailsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.conversationId != widget.conversationId ||
        oldWidget.isPublicChat != widget.isPublicChat) {
      setState(() {
        _messagesFuture = _loadMessages();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPublicChat ? "Public Chat" : "Chat"),
        backgroundColor: Colors.green.shade800,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _messagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final messages = snapshot.data ?? [];

          if (messages.isEmpty) {
            return const Center(child: Text("No messages yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(msg['content'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}