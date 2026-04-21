import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      animationDuration: const Duration(milliseconds: 250),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.medical_services_outlined),
          selectedIcon: Icon(Icons.medical_services_rounded),
          label: 'المخيمات',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2_rounded),
          label: 'المخزون',
        ),
        NavigationDestination(
          icon: Icon(Icons.payments_outlined),
          selectedIcon: Icon(Icons.payments_rounded),
          label: 'المستحقات',
        ),
      ],
    );
  }
}

class AppNavigationRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppNavigationRail({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      extended: MediaQuery.of(context).size.width >= 840,
      backgroundColor: AppTheme.surface,
      indicatorColor: AppTheme.primaryContainer,
      selectedIconTheme: const IconThemeData(color: AppTheme.primary, size: 24),
      unselectedIconTheme: const IconThemeData(
        color: AppTheme.textMuted,
        size: 24,
      ),
      selectedLabelTextStyle: const TextStyle(
        color: AppTheme.primary,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.medical_services_outlined),
          selectedIcon: Icon(Icons.medical_services_rounded),
          label: Text('المخيمات'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2_rounded),
          label: Text('المخزون'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.payments_outlined),
          selectedIcon: Icon(Icons.payments_rounded),
          label: Text('المستحقات'),
        ),
      ],
    );
  }
}

void navigateByIndex(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.campManagementScreen,
        (route) => false,
      );
      break;
    case 1:
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.inventoryScreen,
        (route) => false,
      );
      break;
    case 2:
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.duesReceivablesScreen,
        (route) => false,
      );
      break;
  }
}
