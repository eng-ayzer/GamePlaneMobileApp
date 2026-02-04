import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/player_controller.dart';
import '../../models/player_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_app_bar.dart';
import '../../widgets/main_layout.dart';
import 'player_form_screen.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPlayers());
  }

  void _loadPlayers() {
    final controller = Get.put(PlayerController());
    final authController = Get.find<AuthController>();
    if (authController.isCoach) {
      final teamId = authController.coachTeamId.value;
      if (teamId != null && teamId.isNotEmpty) {
        controller.fetchPlayersByTeam(teamId);
      } else {
        controller.players.clear();
      }
    } else {
      controller.fetchPlayers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppAppBar(title: authController.isCoach ? 'My Players' : 'Players'),
      floatingActionButton: authController.isAdmin
          ? FloatingActionButton(
              onPressed: () => Get.to(() => MainLayout(child: const PlayerFormScreen()))?.then((_) => controller.fetchPlayers()),
              child: const Icon(Icons.add),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value && controller.players.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.players.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  authController.isCoach ? 'No players in your team' : 'No players yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            _loadPlayers();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.players.length,
            itemBuilder: (_, i) {
              final player = controller.players[i];
              return _PlayerCard(
                player: player,
                onTap: () => Get.to(() => MainLayout(child: PlayerFormScreen(playerId: player.playerId)))?.then((_) => controller.fetchPlayers()),
                onDelete: authController.isAdmin
                    ? () => _showDeleteDialog(context, controller, player)
                    : null,
              );
            },
          ),
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, PlayerController controller, PlayerModel player) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Player'),
        content: Text('Delete "${player.fullName}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              final ok = await controller.deletePlayer(player.playerId);
              if (ok) { controller.fetchPlayers(); Get.snackbar('Success', 'Player deleted'); }
              else Get.snackbar('Error', controller.errorMessage.value);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final PlayerModel player;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const _PlayerCard({required this.player, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Text('${player.jerseyNumber ?? '?'}')),
        title: Text(player.fullName.isNotEmpty ? player.fullName : 'Unknown'),
        subtitle: Text('${player.position ?? ''} • ${player.team?.name ?? ''}'),
        onTap: onTap,
        trailing: onDelete != null
            ? IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete)
            : null,
      ),
    );
  }
}
