import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final supabase = Supabase.instance.client;

  final nameController = TextEditingController();
  final bioController = TextEditingController();

  bool loading = false;

  Future<void> createProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    setState(() => loading = true);

    try {
      await supabase.from('users').upsert({
      'id': user.id, // MUST match auth.users.id
      'display_name': nameController.text.trim(),
      'bio': bioController.text.trim(),
      'email': user.email, // IMPORTANT FIX
      'created_at': DateTime.now().toIso8601String(),
    });
      if (!mounted) return;
      context.go('/feed');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating profile: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Display Name"),
            ),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: "Bio"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : createProfile,
              child: Text(loading ? "Saving..." : "Create Profile"),
            )
          ],
        ),
      ),
    );
  }
}