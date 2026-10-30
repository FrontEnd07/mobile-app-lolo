String loginDestination(String? target) {
  final uri = Uri.tryParse(target ?? '/');
  if (uri == null || uri.hasScheme || uri.hasAuthority) return '/';
  final path = uri.path;
  return [
            '/addresses',
            '/profile',
            '/cart',
            '/checkout',
            '/orders',
            '/settings',
            '/stores',
            '/',
          ].contains(path) ||
          path.startsWith('/addresses/') ||
          path.startsWith('/orders/') ||
          path.startsWith('/product/') ||
          path.startsWith('/store/')
      ? uri.toString()
      : '/';
}
