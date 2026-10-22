import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({super.key, required this.url});
  final String? url;
  @override
  Widget build(BuildContext context) {
    Widget placeholder() =>
        const Center(child: Icon(Icons.image_outlined, size: 48));
    if (url == null) return placeholder();
    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder(),
    );
  }
}
