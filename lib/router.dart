import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/events/event_detail_screen.dart';
import 'screens/orders/order_detail_screen.dart';
import 'services/auth_service.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      final isLoggedIn = await AuthService.isLoggedIn();
      final isGoingToLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }
      if (isLoggedIn && isGoingToLogin) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            redirect: (context, state) => '/events',
          ),
          GoRoute(
            path: '/events',
            builder: (context, state) => const SizedBox(), // Will be handled by MainScreen
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SizedBox(), // Will be handled by MainScreen
          ),
        ],
      ),
      GoRoute(
        path: '/event/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return EventDetailScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: '/order/:id',
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return OrderDetailScreen(orderId: orderId);
        },
      ),
    ],
  );
}