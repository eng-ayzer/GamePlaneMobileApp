import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';

import '../bindings/app_binding.dart';
import '../config/app_constants.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import 'drawer_scope.dart';

/// Wraps authenticated pages with AdvancedDrawer - drawer on every page except login
class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final _drawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    ensureDataControllers();
    final authController = Get.find<AuthController>();

    final menuItems = authController.isAdmin
        ? [
            _MenuItem(Icons.dashboard, 'Dashboard', AppRoutes.dashboard),
            _MenuItem(Icons.sports_soccer, 'Fixtures', AppRoutes.fixtures),
            _MenuItem(Icons.emoji_events, 'Leagues', AppRoutes.leagues),
            _MenuItem(Icons.scoreboard, 'Results', AppRoutes.results),
            _MenuItem(Icons.groups, 'Teams', AppRoutes.teams),
            _MenuItem(Icons.person, 'Players', AppRoutes.players),
            _MenuItem(Icons.sports, 'Coaches', AppRoutes.coaches),
            _MenuItem(Icons.stadium, 'Venues', AppRoutes.venues),
            _MenuItem(Icons.gavel, 'Referees', AppRoutes.referees),
            _MenuItem(Icons.people, 'Users', AppRoutes.users),
          ]
        : authController.isCoach
            ? [
                _MenuItem(Icons.dashboard, 'Dashboard', AppRoutes.dashboard),
                _MenuItem(Icons.groups, 'My Team', AppRoutes.teams),
                _MenuItem(Icons.person, 'My Players', AppRoutes.players),
                _MenuItem(Icons.sports_soccer, 'Fixtures', AppRoutes.fixtures),
                _MenuItem(Icons.scoreboard, 'Results', AppRoutes.results),
              ]
            : [
                _MenuItem(Icons.dashboard, 'Dashboard', AppRoutes.dashboard),
                _MenuItem(Icons.sports_soccer, 'Fixtures', AppRoutes.fixtures),
                _MenuItem(Icons.scoreboard, 'Results', AppRoutes.results),
              ];

    return DrawerScope(
      controller: _drawerController,
      child: AdvancedDrawer(
        controller: _drawerController,
        openRatio: 0.78,
        openScale: 0.88,
        animationDuration: const Duration(milliseconds: 300),
        childDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black38, blurRadius: 28, spreadRadius: 2, offset: const Offset(-8, 0)),
          ],
        ),
        drawer: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface.withOpacity(0.97),
                ],
              ),
            ),
            padding: const EdgeInsets.only(top: 28, left: 20, right: 20, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.sports_soccer, size: 36, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'GamePlane',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            authController.currentUser.value?.fullName ?? 'User',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          )),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                            authController.currentUser.value?.role == AppConstants.roleAdmin
                                ? 'Admin'
                                : authController.isCoach
                                    ? 'Coach'
                                    : 'User',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                      Obx(() => Text(
                            authController.currentUser.value?.email ?? '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                          )),
                    ],
                  ),
                ),
                const Divider(height: 32),
                Text('Features', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (_, i) {
                      final item = menuItems[i];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        leading: Icon(item.icon, color: Theme.of(context).colorScheme.primary, size: 24),
                        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                        onTap: () {
                          _drawerController.hideDrawer();
                          if (Get.currentRoute != item.route) {
                            final args = item.route == AppRoutes.teams && authController.isCoach
                                ? {'teamId': authController.coachTeamId.value}
                                : null;
                            Get.offAllNamed(item.route, arguments: args);
                          }
                        },
                      );
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.lock_reset, color: Theme.of(context).colorScheme.primary),
                  title: const Text('Change Password'),
                  onTap: () {
                    _drawerController.hideDrawer();
                    if (Get.currentRoute != AppRoutes.changePassword) {
                      Get.toNamed(AppRoutes.changePassword);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red.shade700),
                  title: Text('Logout', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600)),
                  onTap: () {
                    _drawerController.hideDrawer();
                    authController.logout();
                  },
                ),
              ],
            ),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String route;
  _MenuItem(this.icon, this.title, this.route);
}
