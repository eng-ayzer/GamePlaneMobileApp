import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_constants.dart';
import '../../widgets/app_app_bar.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/fixture_controller.dart';
import '../../controllers/league_controller.dart';
import '../../controllers/team_controller.dart';
import '../../models/league_model.dart';
import '../../widgets/main_layout.dart';
import 'league_form_screen.dart';
import 'league_standings_screen.dart';

class LeaguesScreen extends StatelessWidget {
  const LeaguesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeagueController())..fetchLeagues();
    Get.put(FixtureController())..fetchFixtures();
    Get.put(TeamController())..fetchTeams();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: const AppAppBar(title: 'Leagues'),
      floatingActionButton: authController.isAdmin
          ? FloatingActionButton(
              onPressed: () => Get.to(() => MainLayout(child: const LeagueFormScreen()))?.then((_) => controller.fetchLeagues()),
              child: const Icon(Icons.add),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value && controller.leagues.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.leagues.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text('No leagues yet', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchLeagues,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.leagues.length,
            itemBuilder: (_, i) {
              final league = controller.leagues[i];
              return _LeagueCard(
                league: league,
                onTap: () => Get.to(() => MainLayout(child: LeagueStandingsScreen(league: league))),
                onEdit: authController.isAdmin
                    ? () => Get.to(() => MainLayout(child: LeagueFormScreen(leagueId: league.leagueId)))?.then((_) => controller.fetchLeagues())
                    : null,
                onDelete: authController.isAdmin
                    ? () => _showDeleteDialog(context, controller, league)
                    : null,
              );
            },
          ),
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, LeagueController controller, LeagueModel league) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete League'),
        content: Text('Delete "${league.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              final ok = await controller.deleteLeague(league.leagueId);
              if (ok) { controller.fetchLeagues(); Get.snackbar('Success', 'League deleted'); }
              else Get.snackbar('Error', controller.errorMessage.value);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _LeagueCard extends StatelessWidget {
  final LeagueModel league;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _LeagueCard({required this.league, this.onTap, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.emoji_events)),
        title: Text(league.name),
        subtitle: league.season != null ? Text(league.season!) : null,
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.leaderboard), onPressed: onTap, tooltip: 'Standings'),
            if (onEdit != null) IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            if (onDelete != null) IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
