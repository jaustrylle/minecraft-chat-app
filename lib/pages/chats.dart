import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/app_footer.dart';
import '../components/app_header.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  bool loadingPublicChat = false;

  static const String publicChatId =
      "00000000-0000-0000-0000-000000000001";

  Future<void> openPublicChat() async {
    if (loadingPublicChat) return;

    setState(() {
      loadingPublicChat = true;
    });

    try {
      if (!mounted) return;

      /// Public chat should already exist in database.
      /// We only navigate to it now.
      context.push('/chat/$publicChatId');
    } catch (e) {
      debugPrint('Public chat error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open public chat'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loadingPublicChat = false;
        });
      }
    }
  }

  void openInviteMembers() {
    context.push('/invite-members');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          }
          ),
          title: const Text("Chat"),
        ),

      body: Column(
        children: [
          const AppHeader(),

          Expanded(
            child: Container(
              width: double.infinity,

              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/bg1.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),

              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),

                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 900,
                    ),

                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(
                        color: Colors.green.shade900,
                      ),
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Chats",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          "Connect with other Minecraft players through public and private chats.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 32),

                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            /// PUBLIC CHAT
                            _chatCard(
                              title: "Public Chat",
                              description:
                                  "Join the global Minecraft community chat.",
                              icon: Icons.public,
                              buttonText: loadingPublicChat
                                  ? "Loading..."
                                  : "Enter Public Chat",
                              onPressed: loadingPublicChat
                                  ? null
                                  : openPublicChat,
                            ),

                            /// PRIVATE CHAT
                            _chatCard(
                              title: "Private Chats",
                              description:
                                  "Create or join private conversations.",
                              icon: Icons.group,
                              buttonText: "Invite Members",
                              onPressed: openInviteMembers,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const AppFooter(),
        ],
      ),
    );
  }

  Widget _chatCard({
    required String title,
    required String description,
    required IconData icon,
    required String buttonText,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 320,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.green.shade900.withValues(alpha: 0.35),

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: Colors.green.shade700,
        ),
      ),

      child: Column(
        children: [
          Icon(
            icon,
            size: 52,
            color: Colors.greenAccent,
          ),

          const SizedBox(height: 16),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: onPressed,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),

              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}