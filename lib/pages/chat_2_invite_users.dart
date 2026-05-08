import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Chat2InviteUsersWidget extends StatefulWidget {
  const Chat2InviteUsersWidget({super.key});

  @override
  State<Chat2InviteUsersWidget> createState() =>
      _Chat2InviteUsersWidgetState();
}

class _Chat2InviteUsersWidgetState
    extends State<Chat2InviteUsersWidget> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> users = [];
  Set<String> selectedUserIds = {};

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final data = await supabase.from('users').select();

    setState(() {
      users = List<Map<String, dynamic>>.from(data);
    });
  }

  /// 🔐 stable conversation identity
  String _buildHash(List<String> ids) {
    final sorted = [...ids]..sort();
    final raw = sorted.join('|');
    return sha256.convert(utf8.encode(raw)).toString();
  }

  Future<String> createOrGetConversation() async {
    final currentUser = supabase.auth.currentUser!.id;

    final participants = {
      currentUser,
      ...selectedUserIds,
    }.toList();

    final hash = _buildHash(participants);

    // 1. CHECK EXISTING
    final existing = await supabase
        .from('conversations')
        .select('id')
        .eq('participant_hash', hash)
        .maybeSingle();

    if (existing != null) {
      return existing['id'];
    }

    // 2. CREATE CONVERSATION
    final convo = await supabase
        .from('conversations')
        .insert({
          'type': 'group',
          'participant_hash': hash,
          'created_by': currentUser,
        })
        .select()
        .single();

    final conversationId = convo['id'];

    // 3. INSERT MEMBERS
    await supabase.from('conversation_members').insert(
          participants
              .map((id) => {
                    'conversation_id': conversationId,
                    'user_id': id,
                  })
              .toList(),
        );

    return conversationId;
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = supabase.auth.currentUser!.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invite Users"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, i) {
                final user = users[i];
                final id = user['id'];

                if (id == currentUserId) return const SizedBox();

                return CheckboxListTile(
                  title: Text(user['display_name'] ?? 'User'),
                  value: selectedUserIds.contains(id),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selectedUserIds.add(id);
                      } else {
                        selectedUserIds.remove(id);
                      }
                    });
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: selectedUserIds.isEmpty
                  ? null
                  : () async {
                      final conversationId =
                          await createOrGetConversation();

                      if (!context.mounted) return;

                      context.go('/chat/$conversationId');
                    },
              child: const Text("Start Chat"),
            ),
          ),
        ],
      ),
    );
  }
}