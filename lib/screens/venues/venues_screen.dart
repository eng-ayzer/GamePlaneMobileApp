import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/venue_controller.dart';
import '../../models/venue_model.dart';
import '../../widgets/app_app_bar.dart';
import '../../widgets/main_layout.dart';
import 'venue_form_screen.dart';

class VenuesScreen extends StatelessWidget {
  const VenuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VenueController())..fetchVenues();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: const AppAppBar(title: 'Venues'),
      floatingActionButton: authController.isAdmin
          ? FloatingActionButton(
              onPressed: () => Get.to(() => MainLayout(child: const VenueFormScreen()))?.then((_) => controller.fetchVenues()),
              child: const Icon(Icons.add),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value && controller.venues.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.venues.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stadium_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text('No venues yet', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchVenues,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.venues.length,
            itemBuilder: (_, i) {
              final venue = controller.venues[i];
              return _VenueCard(
                venue: venue,
                onTap: authController.isAdmin
                    ? () => Get.to(() => MainLayout(child: VenueFormScreen(venueId: venue.venueId)))?.then((_) => controller.fetchVenues())
                    : null,
                onDelete: authController.isAdmin
                    ? () => _showDeleteDialog(context, controller, venue)
                    : null,
              );
            },
          ),
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, VenueController controller, VenueModel venue) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Venue'),
        content: Text('Delete "${venue.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              final ok = await controller.deleteVenue(venue.venueId);
              if (ok) { controller.fetchVenues(); Get.snackbar('Success', 'Venue deleted'); }
              else Get.snackbar('Error', controller.errorMessage.value);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  final VenueModel venue;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const _VenueCard({required this.venue, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.stadium)),
        title: Text(venue.name),
        subtitle: venue.location != null ? Text(venue.location!) : null,
        onTap: onTap,
        trailing: onDelete != null
            ? IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete)
            : null,
      ),
    );
  }
}
