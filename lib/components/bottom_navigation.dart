import 'dart:ui';
import 'package:flutter/material.dart';

Widget buildBottomNavBar({
  required int currentIndex,
  required ValueChanged<int> onTap,
}) {
  return Container(
    margin: EdgeInsets.all(16),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white.withAlpha((0.05 * 255).toInt()), // ~12
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha((0.3 * 255).toInt()), // ~76
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
      border: Border.all(
        color: Colors.white.withAlpha((0.1 * 255).toInt()), // ~25
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0), // Glass effect
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.1 * 255).toInt()), // ~25
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(icon: Icons.calendar_today, index: 0, isActive: currentIndex == 0, onTap: onTap),
              _navItem(icon: Icons.home, index: 1, isActive: currentIndex == 1, onTap: onTap),
              _navItem(icon: Icons.notifications, index: 2, isActive: currentIndex == 2, onTap: onTap),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _navItem({
  required IconData icon,
  required int index,
  required bool isActive,
  required ValueChanged<int> onTap,
}) {
  return GestureDetector(
    onTap: () => onTap(index),
    child: AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.blueAccent.withAlpha((0.1 * 255).toInt()) // ~25
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          icon,
          key: ValueKey<int>(index),
          size: 30,
          color: isActive ? Colors.blueAccent : Colors.white54,
        ),
      ),
    ),
  );
}
