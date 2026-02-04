import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/referee_controller.dart';
import '../../models/referee_model.dart';
import '../../widgets/app_app_bar.dart';
import '../../widgets/main_layout.dart';
import 'referee_form_screen.dart';

class RefereesScreen extends StatelessWidget {
  const RefereesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RefereeController())..fetchReferees();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: const AppAppBar(title: 'Referees'),
      floatingActionButton: authController.isAdmin
          ? FloatingActionButton(
              onPressed: () => Get.to(() => MainLayout(child: const RefereeFormScreen()))?.then((_) => controller.fetchReferees()),
              child: const Icon(Icons.add),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value && controller.referees.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.referees.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.gavel_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text('No referees yet', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchReferees,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.referees.length,
            itemBuilder: (_, i) {
              final referee = controller.referees[i];
              return _RefereeCard(
                referee: referee,
                onTap: authController.isAdmin
                    ? () => Get.to(() => MainLayout(child: RefereeFormScreen(refereeId: referee.refereeId)))?.then((_) => controller.fetchReferees())
                    : null,
                onDelete: authController.isAdmin
                    ? () => _showDeleteDialog(context, controller, referee)
                    : null,
              );
            },
          ),
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, RefereeController controller, RefereeModel referee) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Referee'),
        content: Text('Delete "${referee.fullName ?? 'Referee'}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              final ok = await controller.deleteReferee(referee.refereeId);
              if (ok) { controller.fetchReferees(); Get.snackbar('Success', 'Referee deleted'); }
              else Get.snackbar('Error', controller.errorMessage.value);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _RefereeCard extends StatelessWidget {
  final RefereeModel referee;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const _RefereeCard({required this.referee, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.gavel)),
        title: Text(referee.fullName ?? 'Unknown'),
        subtitle: referee.certificationLevel != null ? Text(referee.certificationLevel!) : null,
        onTap: onTap,
        trailing: onDelete != null
            ? IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete)
            : null,
      ),
    );
  }
}
