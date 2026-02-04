import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/league_controller.dart';
import '../../models/league_model.dart';
import '../../widgets/app_app_bar.dart';

class LeagueFormScreen extends StatelessWidget {
  final String? leagueId;

  const LeagueFormScreen({super.key, this.leagueId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LeagueController>();
    final isEdit = leagueId != null;
    LeagueModel? league;

    if (isEdit) {
      league = controller.leagues.firstWhereOrNull((l) => l.leagueId == leagueId);
    }

    final nameController = TextEditingController(text: league?.name ?? '');
    final seasonController = TextEditingController(text: league?.season ?? '');

    return Scaffold(
      appBar: AppAppBar(title: isEdit ? 'Edit League' : 'New League'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: seasonController,
              decoration: const InputDecoration(labelText: 'Season (optional)'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  Get.snackbar('Error', 'Name is required');
                  return;
                }
                final data = {
                  'name': nameController.text.trim(),
                  if (seasonController.text.isNotEmpty) 'season': seasonController.text.trim(),
                };
                final ok = isEdit
                    ? await controller.updateLeague(leagueId!, data)
                    : await controller.createLeague(data);
                if (ok) {
                  Get.snackbar('Success', 'League saved');
                  Get.back();
                } else {
                  Get.snackbar('Error', controller.errorMessage.value);
                }
              },
              child: Text(isEdit ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }
}
