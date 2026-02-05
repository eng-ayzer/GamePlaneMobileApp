import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/coach_controller.dart';
import '../../controllers/league_controller.dart';
import '../../controllers/team_controller.dart';
import '../../models/team_model.dart';
import '../../widgets/app_app_bar.dart';

class TeamFormScreen extends StatelessWidget {
  final String? teamId;

  const TeamFormScreen({super.key, this.teamId});

  @override
  Widget build(BuildContext context) {
    final teamController = Get.find<TeamController>();
    final leagueController = Get.find<LeagueController>();
    final coachController = Get.find<CoachController>();

    if (leagueController.leagues.isEmpty) leagueController.fetchLeagues();
    if (coachController.coaches.isEmpty) coachController.fetchCoaches();

    final isEdit = teamId != null;
    TeamModel? team;
    if (isEdit) {
      team = teamController.teams.firstWhereOrNull((t) => t.teamId == teamId);
    }

    final nameController = TextEditingController(text: team?.name ?? '');
    final homeGroundController = TextEditingController(text: team?.homeGround ?? '');
    final selectedLeagueId = (team?.leagueId ?? leagueController.leagues.firstOrNull?.leagueId ?? '').obs;
    final currentTeamCoach = team != null ? coachController.coaches.where((c) => c.teamId == teamId).firstOrNull : null;
    final selectedCoachId = (currentTeamCoach?.coachId ?? '').obs;

    return Scaffold(
      appBar: AppAppBar(title: isEdit ? 'Edit Team' : 'New Team'),
      body: Obx(() {
        if (leagueController.leagues.isEmpty && !leagueController.isLoading.value) {
          return const Center(child: Text('Create a league first'));
        }
        if (coachController.coaches.isEmpty && !coachController.isLoading.value) {
          return const Center(child: Text('Create a coach first'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Team Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (_) {
                  final leagues = leagueController.leagues;
                  final leagueValueInItems = selectedLeagueId.value.isNotEmpty &&
                      leagues.any((l) => l.leagueId == selectedLeagueId.value);
                  return DropdownButtonFormField<String>(
                    value: leagueValueInItems ? selectedLeagueId.value : null,
                    decoration: const InputDecoration(labelText: 'League'),
                    items: leagues
                        .map((l) => DropdownMenuItem(value: l.leagueId, child: Text(l.name)))
                        .toList(),
                    onChanged: (v) => selectedLeagueId.value = v ?? '',
                  );
                },
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (_) {
                  final coaches = coachController.coaches;
                  final coachValueInItems = selectedCoachId.value.isNotEmpty &&
                      coaches.any((c) => c.coachId == selectedCoachId.value);
                  return DropdownButtonFormField<String>(
                    value: coachValueInItems ? selectedCoachId.value : null,
                    decoration: const InputDecoration(labelText: 'Coach *'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Select a coach' : null,
                    items: coaches
                        .map((c) => DropdownMenuItem(value: c.coachId, child: Text(c.fullName)))
                        .toList(),
                    onChanged: (v) => selectedCoachId.value = v ?? '',
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: homeGroundController,
                decoration: const InputDecoration(labelText: 'Home Ground (optional)'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) {
                    Get.snackbar('Error', 'Name is required');
                    return;
                  }
                  if (selectedLeagueId.value.isEmpty) {
                    Get.snackbar('Error', 'Select a league');
                    return;
                  }
                  if (selectedCoachId.value == null || selectedCoachId.value!.isEmpty) {
                    Get.snackbar('Error', 'Select a coach');
                    return;
                  }
                  final leagueIdValue = isEdit ? team!.leagueId : selectedLeagueId.value;
                  final data = {
                    'name': nameController.text.trim(),
                    'league_id': leagueIdValue,
                    if (homeGroundController.text.isNotEmpty) 'home_ground': homeGroundController.text.trim(),
                  };
                  bool ok;
                  String? newTeamId;
                  if (isEdit) {
                    ok = await teamController.updateTeam(teamId!, data);
                    newTeamId = teamId;
                  } else {
                    newTeamId = await teamController.createTeam(data);
                    ok = newTeamId != null;
                  }
                  if (ok && newTeamId != null) {
                    final coachOk = await coachController.updateCoach(selectedCoachId.value!, {'team_id': newTeamId});
                    if (coachOk) {
                      Get.snackbar('Success', 'Team saved');
                      Get.back();
                    } else {
                      Get.snackbar('Warning', 'Team created but coach assignment failed');
                    }
                  } else if (ok) {
                    Get.snackbar('Success', 'Team saved');
                    Get.back();
                  } else {
                    Get.snackbar('Error', teamController.errorMessage.value);
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
