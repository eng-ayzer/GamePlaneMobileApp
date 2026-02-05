import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/league_controller.dart';
import '../../controllers/team_controller.dart';
import '../../models/team_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_app_bar.dart';
import '../../widgets/main_layout.dart';
import 'team_form_screen.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTeams());
  }

  void _loadTeams() {
    final controller = Get.put(TeamController());
    final authController = Get.find<AuthController>();
    if (authController.isCoach) {
      final teamId = Get.arguments?['teamId'] as String? ?? authController.coachTeamId.value;
      if (teamId != null && teamId.isNotEmpty) {
        controller.getTeamById(teamId).then((team) {
          if (team != null) controller.teams.value = [team];
          else controller.teams.clear();
        });
      } else {
        controller.teams.clear();
      }
    } else {
      controller.fetchTeams();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppAppBar(title: authController.isCoach ? 'My Team' : 'Teams'),
      floatingActionButton: authController.isAdmin
          ? FloatingActionButton(
              onPressed: () => Get.to(() => MainLayout(child: const TeamFormScreen()))?.then((_) => controller.fetchTeams()),
              child: const Icon(Icons.add),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value && controller.teams.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.teams.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.groups_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  authController.isCoach ? 'No team assigned' : 'No teams yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            _loadTeams();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.teams.length,
            itemBuilder: (_, i) {
              final team = controller.teams[i];
              return _TeamCard(
                team: team,
                onTap: () => Get.toNamed('${AppRoutes.teams}/${team.teamId}/detail'),
                onEdit: authController.isAdmin
                    ? () => Get.to(() => MainLayout(child: TeamFormScreen(teamId: team.teamId)))?.then((_) => controller.fetchTeams())
                    : null,
                onDelete: authController.isAdmin
                    ? () => _showDeleteDialog(context, controller, team)
                    : null,
              );
            },
          ),
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, TeamController controller, TeamModel team) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Team'),
        content: Text('Delete "${team.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              final ok = await controller.deleteTeam(team.teamId);
              if (ok) { controller.fetchTeams(); Get.snackbar('Success', 'Team deleted'); }
              else Get.snackbar('Error', controller.errorMessage.value);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final TeamModel team;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _TeamCard({required this.team, this.onTap, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.groups)),
        title: Text(team.name),
        subtitle: team.league?.name != null ? Text(team.league!.name) : null,
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null) IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            if (onDelete != null) IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
