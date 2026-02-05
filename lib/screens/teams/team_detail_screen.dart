import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/player_controller.dart';
import '../../controllers/team_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_app_bar.dart';

class TeamDetailScreen extends StatelessWidget {

  const TeamDetailScreen({super.key, this.teamId});

  final String? teamId;

  @override
  Widget build(BuildContext context) {
    final id = teamId ?? Get.parameters['id'] ?? '';
    final teamController = Get.find<TeamController>();
    final playerController = Get.put(PlayerController())..fetchPlayersByTeam(id);

    final team = teamController.teams.firstWhereOrNull((t) => t.teamId == id);

    if (team == null) {
      return Scaffold(
        appBar: const AppAppBar(title: 'Team'),
        body: const Center(child: Text('Team not found')),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppAppBar(
          title: team.name,
          bottom: const TabBar(
            tabs: [Tab(text: 'Players'), Tab(text: 'Fixtures')],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() {
              if (playerController.isLoading.value && playerController.players.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (playerController.players.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('No players', style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: playerController.players.length,
                itemBuilder: (_, i) {
                  final p = playerController.players[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${p.jerseyNumber ?? '?'}')),
                    title: Text(p.fullName.isNotEmpty ? p.fullName : 'Unknown'),
                    subtitle: Text(p.position ?? ''),
                    onTap: () => Get.toNamed('${AppRoutes.players}/${p.playerId}'),
                  );
                },
              );
            }),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed(AppRoutes.fixtures, arguments: {'teamId': id}),
                child: const Text('View Fixtures'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
