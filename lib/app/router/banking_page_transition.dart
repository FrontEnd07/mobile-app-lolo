import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<void> bankingPage({
  required GoRouterState state,
  required Widget child,
}) => CustomTransitionPage<void>(
  key: state.pageKey,
  child: child,
  transitionDuration: const Duration(milliseconds: 380),
  reverseTransitionDuration: const Duration(milliseconds: 380),
  transitionsBuilder: (_, animation, secondaryAnimation, child) {
    final incoming = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInQuart,
    );
    final outgoing = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInQuart,
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(incoming),
          child: AnimatedBuilder(
            animation: Listenable.merge([incoming, outgoing]),
            child: child,
            builder: (_, child) {
              final radius = 40 * (1 - incoming.value);
              return Transform.translate(
                offset: Offset(-50 * outgoing.value, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(radius),
                  ),
                  child: child,
                ),
              );
            },
          ),
        ),
        IgnorePointer(
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: .42).animate(outgoing),
            child: const ColoredBox(color: Colors.black),
          ),
        ),
      ],
    );
  },
);
