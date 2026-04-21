import 'package:flutter/material.dart';

import '../presentation/camp_management_screen/camp_management_screen.dart';
import '../presentation/dues_receivables_screen/dues_receivables_screen.dart';
import '../presentation/inventory_screen/inventory_screen.dart';
import '../presentation/login_screen/login_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String duesReceivablesScreen = '/dues-receivables-screen';
  static const String campManagementScreen = '/camp-management-screen';
  static const String inventoryScreen = '/inventory-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    loginScreen: (context) => const LoginScreen(),
    duesReceivablesScreen: (context) => const DuesReceivablesScreen(),
    campManagementScreen: (context) => const CampManagementScreen(),
    inventoryScreen: (context) => const InventoryScreen(),
  };
}
