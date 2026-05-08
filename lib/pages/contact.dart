import 'package:flutter/material.dart';
import '../components/app_header.dart';
import '../components/app_footer.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool sent = false;
  bool loading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final categoryController = TextEditingController();
  final messageController = TextEditingController();

  Future<void> handleSubmit() async {
  final name = nameController.text.trim();
  final email = emailController.text.trim();
  final category = categoryController.text.trim();
  final message = messageController.text.trim();

  if (message.isEmpty) return;

  setState(() => loading = true);

  try {
    // Future Supabase insert placeholder
    // await supabase.from('contact_messages').insert({
    //   'name': name,
    //   'email': email,
    //   'category': category,
    //   'message': message,
    //   'created_at': DateTime.now().toIso8601String(),
    // });

    debugPrint("Contact form:");
    debugPrint("Name: $name");
    debugPrint("Email: $email");
    debugPrint("Category: $category");
    debugPrint("Message: $message");

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => sent = true);
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to send: $e")),
    );
  } finally {
    if (mounted) setState(() => loading = false);
  }
}

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    categoryController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(),

          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  constraints: const BoxConstraints(maxWidth: 900),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Contact",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (!sent) ...[
                        _buildField("Name", nameController),
                        _buildField("Email", emailController),
                        _buildField("Category", categoryController),
                        _buildField("Message", messageController, maxLines: 4),

                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: loading ? null : handleSubmit,
                          child: Text(loading ? "Sending..." : "Send Message"),
                        ),
                      ] else ...[
                        const Text(
                          "Message sent!",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => sent = false);
                          },
                          child: const Text("Send another"),
                        ),
                      ],
                    ],
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

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}