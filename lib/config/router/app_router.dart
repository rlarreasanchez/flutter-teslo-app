import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/products.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
      initialLocation: '/check-auth',
      refreshListenable: goRouterNotifier,
      routes: [
        //* Check Auth Route
        GoRoute(
          path: '/check-auth',
          pageBuilder: (context, state) => CupertinoPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const CheckAuthStatusScreen(),
          ),
        ),

        //* Auth Route
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => CupertinoPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const LoginScreen(),
          ),
        ),

        //* Register Route
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) => CupertinoPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const RegisterScreen(),
          ),
        ),

        //* Product Routes
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => CupertinoPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const ProductsScreen(),
          ),
        ),
      ],
      redirect: (context, state) {
        final isGoingTo = state.subloc;
        final authStatus = goRouterNotifier.authStatus;

        if (isGoingTo == '/check-status' && authStatus == AuthStatus.checking) {
          return null;
        }
        if (authStatus == AuthStatus.notAuthenticated) {
          if (isGoingTo == '/login' || isGoingTo == '/register') return null;

          return '/login';
        }
        if (authStatus == AuthStatus.authenticated) {
          if (isGoingTo == '/login' ||
              isGoingTo == '/register' ||
              isGoingTo == '/check-auth') return '/';
        }

        return null;
      });
});
