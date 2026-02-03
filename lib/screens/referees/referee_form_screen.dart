import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/referee_controller.dart';
import '../../models/referee_model.dart';
import '../../widgets/app_app_bar.dart';

class RefereeFormScreen extends StatelessWidget {
  final String? refereeId;

  const RefereeFormScreen({super.key, this.refereeId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RefereeController>();
    final isEdit = refereeId != null;
    final referee = isEdit ? controller.referees.where((r) => r.refereeId == refereeId).firstOrNull : null;

    final nameController = TextEditingController(text: referee?.fullName ?? '');
    final certController = TextEditingController(text: referee?.certificationLevel ?? '');

    return Scaffold(
      appBar: AppAppBar(title: isEdit ? 'Edit Referee' : 'New Referee'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: certController,
              decoration: const InputDecoration(labelText: 'Certification Level'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final data = {
                  if (nameController.text.isNotEmpty) 'full_name': nameController.text.trim(),
                  if (certController.text.isNotEmpty) 'certification_level': certController.text.trim(),
                };
                if (data.isEmpty) {
                  Get.snackbar('Error', 'At least one field is required');
                  return;
                }
                final ok = isEdit
                    ? await controller.updateReferee(refereeId!, data)
                    : await controller.createReferee(data);
                if (ok) {
                  Get.snackbar('Success', 'Referee saved');
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
