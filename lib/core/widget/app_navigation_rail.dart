import 'package:flutter/material.dart';
import '../shared/navigation_item.dart';

class AppNavigationRail extends StatelessWidget {
  final List<NavItem> navItems;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const AppNavigationRail({
    super.key,
    required this.navItems,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      minWidth: 72,
      useIndicator: true,
      labelType: NavigationRailLabelType.all,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      destinations: navItems.map((item) {
        return NavigationRailDestination(
          icon: Icon(item.icon, size: 28),
          selectedIcon: Icon(item.icon, size: 28),
          label: Text(
            item.label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),

      trailing: const SizedBox(height: 20),
    );
  }
}
