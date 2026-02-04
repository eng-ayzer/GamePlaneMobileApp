import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/player_controller.dart';
import '../../controllers/team_controller.dart';
import '../../models/player_model.dart';
import '../../widgets/app_app_bar.dart';

class PlayerFormScreen extends StatelessWidget {
  final String? playerId;

  const PlayerFormScreen({super.key, this.playerId});

  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<PlayerController>();
    final teamController = Get.find<TeamController>();

    if (teamController.teams.isEmpty) {
      teamController.fetchTeams();
    }

    final isEdit = playerId != null;
    final player = isEdit ? playerController.players.firstWhereOrNull((p) => p.playerId == playerId) : null;

    final firstNameController = TextEditingController(text: player?.firstName ?? '');
    final lastNameController = TextEditingController(text: player?.lastName ?? '');
    final positionController = TextEditingController(text: player?.position ?? '');
    final numberController = TextEditingController(text: player?.jerseyNumber?.toString() ?? '');
    final selectedTeamId = (player?.teamId ?? teamController.teams.firstOrNull?.teamId ?? '').obs;

    return Scaffold(
      appBar: AppAppBar(title: isEdit ? 'Edit Player' : 'New Player'),
      body: Obx(() {
        if (teamController.teams.isEmpty && !teamController.isLoading.value) {
          return const Center(child: Text('Create a team first'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedTeamId.value.isEmpty ? null : selectedTeamId.value,
                decoration: const InputDecoration(labelText: 'Team'),
                items: teamController.teams
                    .map((t) => DropdownMenuItem(value: t.teamId, child: Text(t.name)))
                    .toList(),
                onChanged: isEdit ? null : (v) => selectedTeamId.value = v ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: positionController,
                decoration: const InputDecoration(labelText: 'Position (e.g. FW, MF, DF, GK)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Jersey Number'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (firstNameController.text.trim().isEmpty && lastNameController.text.trim().isEmpty) {
                    Get.snackbar('Error', 'Name is required');
                    return;
                  }
                  final teamId = isEdit ? player!.teamId : selectedTeamId.value;
                  if (teamId.isEmpty) {
                    Get.snackbar('Error', 'Select a team');
                    return;
                  }
                  final data = {
                    'firstName': firstNameController.text.trim(),
                    'lastName': lastNameController.text.trim(),
                    'teamId': teamId,
                    if (positionController.text.isNotEmpty) 'position': positionController.text.trim(),
                    if (numberController.text.isNotEmpty) 'number': int.tryParse(numberController.text) ?? 0,
                  };
                  final ok = isEdit
                      ? await playerController.updatePlayer(playerId!, data)
                      : await playerController.createPlayer(data);
                  if (ok) {
                    Get.snackbar('Success', 'Player saved');
                    Get.back();
                  } else {
                    Get.snackbar('Error', playerController.errorMessage.value);
                  }
                },
                child: Text(isEdit ? 'Update' : 'Create'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
