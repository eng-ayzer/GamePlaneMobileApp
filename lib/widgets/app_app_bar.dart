import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'drawer_scope.dart';

/// AppBar with drawer toggle - use when wrapped in MainLayout
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    final drawerController = DrawerScope.maybeOf(context);

    return AppBar(
      leading: leading ??
          (drawerController != null
              ? IconButton(
                  icon: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: drawerController,
                    builder: (_, value, __) => Icon(value.visible ? Icons.close : Icons.menu),
                  ),
                  onPressed: () => drawerController.toggleDrawer(),
                )
              : null),
      title: Text(title),
      actions: actions,
      bottom: bottom,
    );
  }
}
