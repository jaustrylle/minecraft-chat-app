import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({super.key});

  static String routePath = '/create-post';

  @override
  State<CreatePostWidget> createState() =>
      _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final supabase = Supabase.instance.client;

  final TextEditingController textController =
      TextEditingController();

  File? selectedImage;
  bool isUploading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file =
        await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    setState(() {
      selectedImage = File(file.path);
    });
  }

  Future<String?> uploadImage(File file) async {
    final fileName =
        'posts/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage
        .from('posts')
        .upload(fileName, file);

    return supabase.storage
        .from('posts')
        .getPublicUrl(fileName);
  }

  Future<void> createPost() async {
    final text = textController.text.trim();

    if (text.isEmpty && selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add text or image')),
      );
      return;
    }

    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in')),
      );
      return;
    }

    if (isUploading) return; // prevent spam
    setState(() => isUploading = true);

    try {
      String? imageUrl;

      if (selectedImage != null) {
        imageUrl = await uploadImage(selectedImage!);
      }

      await supabase.from('posts').insert({
        'user_id': user.id,
        'caption': text.isEmpty ? null : text,
        'media_url': imageUrl,
        'media_type': selectedImage != null ? 'image' : null,
      });

      if (!mounted) return;

      context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isUploading = false);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: isUploading ? null : createPost,
            child: Text(isUploading ? 'Posting...' : 'Post'),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: textController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'What do you want to share?',
              ),
            ),

            const SizedBox(height: 12),

            if (selectedImage != null)
              Image.file(selectedImage!, height: 200),

            const SizedBox(height: 12),

            Row(
              children: [
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text('Add Image'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}