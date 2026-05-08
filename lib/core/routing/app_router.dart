import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minecraft_companion/pages/search_members.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../pages/feed.dart';
import '../../pages/login.dart';
import '../../pages/create_account.dart';
import '../../pages/chat_2_details.dart';
import '../../pages/create_post.dart';
import '../../pages/forgot_password.dart';
import '../../pages/change_password.dart';
import '../../pages/about.dart';
import '../../pages/knowledge.dart';
import '../../pages/crafting.dart';
import '../../pages/create_profile.dart';
import '../../pages/main_profile.dart';
import '../../pages/view_other_profile.dart';
import '../../pages/edit_settings.dart';
import '../../pages/chats.dart';

/// Auth listener for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}

/// Global logout helper (correct place)
Future<void> logout(BuildContext context) async {
  await Supabase.instance.client.auth.signOut();
  if (context.mounted) {
    context.go('/login');
  }
}

class AppRouter {
  static final supabase = Supabase.instance.client;

  static final GoRouter router = GoRouter(
    refreshListenable: GoRouterRefreshStream(
      Supabase.instance.client.auth.onAuthStateChange,
    ),

    initialLocation: '/',

    redirect: (context, state) {
      final session = supabase.auth.currentSession;
      final loggedIn = session != null;

      final path = state.uri.path;

      final authRoutes = {
        '/login',
        '/register',
        '/forgot-password',
        '/change-password',
      };

      final isAuthRoute = authRoutes.contains(path);

      if (!loggedIn && !isAuthRoute) {
        return '/login';
      }

      if (loggedIn && isAuthRoute) {
        return '/feed';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const FeedPage(),
      ),

      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const CreateAccountWidget(),
      ),

      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordWidget(),
      ),

      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordWidget(),
      ),

      GoRoute(
        path: '/feed',
        builder: (context, state) => const FeedPage(),
      ),

      GoRoute(
        path: '/knowledge',
        builder: (context, state) => const KnowledgePage(),
      ),

      GoRoute(
        path: '/crafting',
        builder: (context, state) => const CraftingPage(),
      ),

      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutPage(),
      ),

      GoRoute(
        path: '/chats',
        builder: (context, state) => const ChatsPage(),
      ),

      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];

          if (id == null || id.isEmpty) {
            return const Scaffold(
              body: Center(child: Text("Invalid chat ID")),
            );
          }

          return Chat2DetailsWidget(conversationId: id);
        },
      ),

      GoRoute(
        path: '/invite-users',
        builder: (context, state) => const SearchMembersPage(),
      ),

      GoRoute(
        path: '/create-post',
        builder: (context, state) => const CreatePostWidget(),
      ),

      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditSettingsWidget(),
      ),

      GoRoute(
        path: '/profile',
        builder: (context, state) => const MainProfileWidget(),
      ),

      GoRoute(
        path: '/edit-settings.dart',
        builder: (context, state) => const EditSettingsWidget(),
      ),

      GoRoute(
        path: '/user/:id',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return ViewOtherProfilePage(userId: userId);
        },
      ),
    ],
  );
}