import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

/// Provides drawer controller to descendant widgets
class DrawerScope extends InheritedWidget {
  final AdvancedDrawerController controller;

  const DrawerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  static AdvancedDrawerController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DrawerScope>()?.controller;
  }

  @override
  bool updateShouldNotify(DrawerScope oldWidget) => controller != oldWidget.controller;
}
