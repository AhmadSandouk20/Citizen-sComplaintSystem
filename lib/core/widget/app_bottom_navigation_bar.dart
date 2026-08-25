import 'package:flutter/material.dart';

import '../shared/navigation_item.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final List<NavItem> navItems;
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.navItems,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: navItems.map((item) {
        return BottomNavigationBarItem(
          icon: _NavIcon(icon: item.icon, badgeCount: item.badgeCount),
          label: item.label,
        );
      }).toList(),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon, required this.badgeCount});

  final IconData icon;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon);
    if (badgeCount <= 0) return iconWidget;
    return Badge(
      label: Text(badgeCount > 99 ? '99+' : '$badgeCount'),
      child: iconWidget,
    );
  }
}
