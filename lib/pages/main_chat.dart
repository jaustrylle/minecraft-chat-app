import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Conversation {
  final String id;
  final DateTime createdAt;
  final String? lastMessage;

  Conversation({
    required this.id,
    required this.createdAt,
    this.lastMessage,
  });

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      lastMessage: map['last_message'],
    );
  }
}

class MainChatWidget extends StatefulWidget {
  const MainChatWidget({super.key});

  @override
  State<MainChatWidget> createState() => _MainChatWidgetState();
}

class _MainChatWidgetState extends State<MainChatWidget> {
  final supabase = Supabase.instance.client;

  Stream<List<Conversation>>? stream;

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  void _initStream() {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    stream = supabase
        .from('conversations')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .asyncMap((_) async {
          final memberships = await supabase
              .from('conversation_members')
              .select('conversation_id')
              .eq('user_id', user.id);

          final ids = memberships
              .map((e) => e['conversation_id'])
              .toList();

          if (ids.isEmpty) return [];

          final conversations = await supabase
              .from('conversations')
              .select()
              .inFilter('id', ids)
              .order('created_at', ascending: false);

          return conversations
              .map((e) => Conversation.fromMap(e))
              .toList();
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'My Chats',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: Colors.greenAccent,
          ),
        ),
      ),

      body: user == null
          ? const Center(
              child: Text(
                "No user session",
                style: TextStyle(color: Colors.white),
              ),
            )
          : StreamBuilder<List<Conversation>>(
              stream: stream,

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final conversations = snapshot.data!;

                if (conversations.isEmpty) {
                  return const Center(
                    child: Text(
                      "No chats yet",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, i) {
                    final convo = conversations[i];

                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.chat, color: Colors.white),
                      ),

                      title: Text(
                        "Conversation",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      subtitle: Text(
                        convo.lastMessage ?? "No messages yet",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),

                      onTap: () {
                        context.push('/chat/${convo.id}');
                      },
                    );
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => context.push('/invite-users'),
        child: const Icon(Icons.add),
      ),
    );
  }
}