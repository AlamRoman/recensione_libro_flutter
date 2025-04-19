import 'package:flutter/material.dart';

class NavigationController {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationController(this.navigatorKey);

  void goToHome() => navigatorKey.currentState?.pushReplacementNamed('/home');
  void goToRegister() => navigatorKey.currentState?.pushNamed('/register');
  void goToLogin() => navigatorKey.currentState?.pushNamed('/login');
  void goToFormat() => navigatorKey.currentState?.pushReplacementNamed('/format');
}
