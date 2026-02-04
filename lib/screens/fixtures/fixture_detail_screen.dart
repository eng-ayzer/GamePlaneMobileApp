import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/app_constants.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/fixture_controller.dart';
import '../../controllers/result_controller.dart';
import '../../models/fixture_model.dart';
import '../../widgets/app_app_bar.dart';

void _showAddResultDialog(BuildContext context, ResultController resultController, FixtureController fixtureController, String fixtureId) {
  final homeCtrl = TextEditingController();
  final awayCtrl = TextEditingController();
  Get.dialog(
    AlertDialog(
      title: const Text('Add Result'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: homeCtrl, decoration: const InputDecoration(labelText: 'Home Score'), keyboardType: TextInputType.number),
          TextField(controller: awayCtrl, decoration: const InputDecoration(labelText: 'Away Score'), keyboardType: TextInputType.number),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            final home = int.tryParse(homeCtrl.text) ?? 0;
            final away = int.tryParse(awayCtrl.text) ?? 0;
            Get.back();
            final ok = await resultController.createFixtureResult(fixtureId, home, away);
            if (ok) {
              Get.snackbar('Success', 'Result added');
              fixtureController.fetchFixtures();
            } else {
              Get.snackbar('Error', resultController.errorMessage.value);
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

class FixtureDetailScreen extends StatelessWidget {
  final String fixtureId;

  const FixtureDetailScreen({super.key, required this.fixtureId});

  @override
  Widget build(BuildContext context) {
    final fixtureController = Get.find<FixtureController>();
    final resultController = Get.put(ResultController());
    final authController = Get.find<AuthController>();

    final fixture = fixtureController.fixtures.firstWhereOrNull((f) => f.fixtureId == fixtureId);

    if (fixture == null) {
      return Scaffold(
        appBar: const AppAppBar(title: 'Fixture'),
        body: const Center(child: Text('Fixture not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('${fixture.homeTeam?.name ?? ''} vs ${fixture.awayTeam?.name ?? ''}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SelectableText(DateFormat('EEEE, MMMM d, y').format(fixture.matchDate), style: Theme.of(context).textTheme.titleMedium),
                    SelectableText(DateFormat('HH:mm').format(fixture.matchDate), style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: SelectableText(fixture.homeTeam?.name ?? 'TBD', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge)),
                        SelectableText('${fixture.result?.homeScore ?? 0} - ${fixture.result?.awayScore ?? 0}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        Expanded(child: SelectableText(fixture.awayTeam?.name ?? 'TBD', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (fixture.venue != null) SelectableText('at ${fixture.venue!.name}', style: Theme.of(context).textTheme.bodyMedium),
                    if (fixture.referee != null) SelectableText('Referee: ${fixture.referee!.fullName ?? ''}', style: Theme.of(context).textTheme.bodySmall),
                    Chip(label: Text(fixture.status), padding: EdgeInsets.zero),
                  ],
                ),
              ),
            ),
            if (authController.isAdmin && fixture.status == 'Scheduled') ...[
              const SizedBox(height: 24),
              const Text('Update status or add result', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: AppConstants.fixtureStatuses.map((s) => ActionChip(
                  label: Text(s),
                  onPressed: () async {
                    final ok = await fixtureController.updateFixtureStatus(fixtureId, s);
                    if (ok) Get.snackbar('Success', 'Status updated');
                    else Get.snackbar('Error', fixtureController.errorMessage.value);
                  },
                )).toList(),
              ),
              if (fixture.result == null)
                ElevatedButton(
                  onPressed: () => _showAddResultDialog(context, resultController, fixtureController, fixtureId),
                  child: const Text('Add Result'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
