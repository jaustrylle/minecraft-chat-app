import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class EditSettingsWidget extends StatefulWidget {
  const EditSettingsWidget({super.key});

  @override
  State<EditSettingsWidget> createState() =>
      _EditSettingsWidgetState();
}

class _EditSettingsWidgetState
    extends State<EditSettingsWidget> {
  final supabase = Supabase.instance.client;

  final TextEditingController displayNameController =
      TextEditingController();

  final TextEditingController bioController =
      TextEditingController();

  bool loadingProfile = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  void dispose() {
    displayNameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> loadUser() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      if (mounted) context.go('/login');
      return;
    }

    try {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data != null) {
        displayNameController.text =
            data['display_name'] ?? '';
        bioController.text = data['bio'] ?? '';
      }
    } catch (e) {
      debugPrint('Load user error: $e');
    } finally {
      if (mounted) {
        setState(() => loadingProfile = false);
      }
    }
  }

  Future<void> saveSettings() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    setState(() => saving = true);

    try {
      await supabase.from('users').update({
        'display_name':
            displayNameController.text.trim(),
        'bio': bioController.text.trim(),
      }).eq('id', user.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );

      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();

    if (!mounted) return;

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    if (loadingProfile) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.greenAccent),
        ),
        iconTheme: const IconThemeData(
          color: Colors.greenAccent,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.greenAccent),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Profile Settings",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: displayNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    labelStyle:
                        TextStyle(color: Colors.greenAccent),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: bioController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    labelStyle:
                        TextStyle(color: Colors.greenAccent),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: saving ? null : saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                  child: Text(
                    saving ? 'Saving...' : 'Save Changes',
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}