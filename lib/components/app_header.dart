import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/sky_animation.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  SupabaseClient get supabase => Supabase.instance.client;

  Future<void> logout(BuildContext context) async {
    await supabase.auth.signOut();
    if (context.mounted) {
      context.go('/login');
    }
  }

  void handleLogin(BuildContext context) {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final isLoggedIn = user != null;

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: const SkyAnimation(),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.black.withOpacity(0.4),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// LEFT SIDE
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/favicon.ico",
                        height: 38,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Minecraft Guide",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ],
                  ),

                  /// RIGHT SIDE (LOGIN / LOGOUT)
                  isLoggedIn
                      ? IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => logout(context),
                        )
                      : ElevatedButton(
                          onPressed: () => handleLogin(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}