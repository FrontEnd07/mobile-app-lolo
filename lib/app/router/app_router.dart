import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_new/features/auth/index.dart';
import 'package:ecommerce_new/pages/account/index.dart';
import 'package:ecommerce_new/pages/auth/index.dart';
import 'package:ecommerce_new/pages/cart/index.dart';
import 'package:ecommerce_new/pages/checkout/index.dart';
import 'package:ecommerce_new/pages/home/index.dart';
import 'package:ecommerce_new/pages/not_found/index.dart';
import 'package:ecommerce_new/pages/product/index.dart';
import 'package:ecommerce_new/pages/settings/index.dart';
import 'package:ecommerce_new/pages/store/index.dart';
import 'package:ecommerce_new/shared/lib/login_destination.dart';

export 'package:ecommerce_new/shared/lib/login_destination.dart'
    show loginDestination;

import 'banking_page_transition.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final changes = ValueNotifier(false);
  ref.listen(
    authProvider.select((state) => state.isAuthenticated),
    (_, authenticated) => changes.value = authenticated,
  );
  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: changes,
    errorPageBuilder: (_, state) =>
        bankingPage(state: state, child: const NotFoundPage()),
    redirect: (context, state) {
      final authenticated = ref.read(authProvider).isAuthenticated;
      final path = state.matchedLocation;
      final authRoute = path == '/login' || path == '/register';
      final protected =
          [
            '/profile',
            '/cart',
            '/checkout',
            '/orders',
            '/addresses',
          ].contains(path) ||
          path.startsWith('/orders/') ||
          path.startsWith('/addresses/');
      if (!authenticated && protected) {
        return '/login?from=${Uri.encodeComponent(state.uri.toString())}';
      }
      if (authenticated && authRoute) {
        return loginDestination(state.uri.queryParameters['from']);
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/stores',
        pageBuilder: (_, state) =>
            bankingPage(state: state, child: const StoresPage()),
      ),
      GoRoute(
        path: '/store/:channelToken',
        pageBuilder: (_, state) => bankingPage(
          state: state,
          child: StorePage(channelToken: state.pathParameters['channelToken']!),
        ),
      ),
      GoRoute(
        path: '/addresses',
        pageBuilder: (_, state) =>
            bankingPage(state: state, child: const AddressesPage()),
      ),
      GoRoute(
        path: '/addresses/new',
        pageBuilder: (_, state) =>
            bankingPage(state: state, child: const EditAddressPage()),
      ),
      GoRoute(
        path: '/addresses/:id',
        pageBuilder: (_, state) => bankingPage(
          state: state,
          child: EditAddressPage(id: state.pathParameters['id']!),
        ),
      ),

      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (_, state) =>
            bankingPage(state: state, child: const HomePage()),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (_, state) =>
            bankingPage(state: state, child: const PhoneAuthPage()),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (_, state) =>
            bankingPage(state: state, child: const PhoneAuthPage()),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (_, state) =>
            bankingPage(state: state, child: const ProfilePage()),
      ),
      GoRoute(
        path: '/orders',
        pageBuilder: (_, state) =>
            bankingPage(state: state, child: const OrdersPage()),
      ),
      GoRoute(
        path: '/orders/:code',
        pageBuilder: (_, state) => bankingPage(
          state: state,
          child: OrderDetailPage(code: state.pathParameters['code']!),
        ),
      ),
      GoRoute(
        path: '/cart',
        pageBuilder: (_, state) =>
            bankingPage(state: state, child: const CartPage()),
      ),
      GoRoute(
        path: '/checkout',
        pageBuilder: (_, state) =>
            bankingPage(state: state, child: const CheckoutPage()),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (_, state) =>
            bankingPage(state: state, child: const SettingsPage()),
      ),
      GoRoute(
        path: '/product/:slug',
        pageBuilder: (_, state) => bankingPage(
          state: state,
          child: ProductPage(
            slug: state.pathParameters['slug']!,
            channelToken: state.uri.queryParameters['channel'],
          ),
        ),
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    changes.dispose();
  });
  return router;
});
