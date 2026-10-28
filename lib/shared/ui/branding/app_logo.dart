import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height = 28});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'LOLO.tj',
      image: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Image.asset(
            'assets/branding/lolo-logo.png',
            height: height,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
