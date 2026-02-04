import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/venue_controller.dart';
import '../../models/venue_model.dart';
import '../../widgets/app_app_bar.dart';

class VenueFormScreen extends StatelessWidget {
  final String? venueId;

  const VenueFormScreen({super.key, this.venueId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VenueController>();
    final isEdit = venueId != null;
    final venue = isEdit ? controller.venues.firstWhereOrNull((v) => v.venueId == venueId) : null;

    final nameController = TextEditingController(text: venue?.name ?? '');
    final locationController = TextEditingController(text: venue?.location ?? '');

    return Scaffold(
      appBar: AppAppBar(title: isEdit ? 'Edit Venue' : 'New Venue'),
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
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location (optional)'),
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
                  if (locationController.text.isNotEmpty) 'location': locationController.text.trim(),
                };
                final ok = isEdit
                    ? await controller.updateVenue(venueId!, data)
                    : await controller.createVenue(data);
                if (ok) {
                  Get.snackbar('Success', 'Venue saved');
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
