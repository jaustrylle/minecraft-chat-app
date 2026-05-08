import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

Future<void> logout(BuildContext context) async {
  await Supabase.instance.client.auth.signOut();
  if (context.mounted) {
    context.go('/login');
  }
}