import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/coach_controller.dart';
import '../../models/coach_model.dart';
import '../../widgets/app_app_bar.dart';
import '../../widgets/main_layout.dart';
import 'coach_form_screen.dart';

class CoachesScreen extends StatelessWidget {
  const CoachesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CoachController())..fetchCoaches();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: const AppAppBar(title: 'Coaches'),
      floatingActionButton: authController.isAdmin
          ? FloatingActionButton(
              onPressed: () => Get.to(() => MainLayout(child: const CoachFormScreen()))?.then((_) => controller.fetchCoaches()),
              child: const Icon(Icons.add),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value && controller.coaches.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.coaches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text('No coaches yet', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchCoaches,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.coaches.length,
            itemBuilder: (_, i) {
              final coach = controller.coaches[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.sports)),
                  title: Text(coach.fullName),
                  subtitle: Text('${coach.licenseLevel ?? ''} • ${coach.team?.name ?? 'No team'}'),
                  onTap: authController.isAdmin
                      ? () => Get.to(() => MainLayout(child: CoachFormScreen(coachId: coach.coachId)))?.then((_) => controller.fetchCoaches())
                      : null,
                  trailing: authController.isAdmin
                      ? IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            Get.dialog(AlertDialog(
                              title: const Text('Delete Coach'),
                              content: Text('Delete "${coach.fullName}"?'),
                              actions: [
                                TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () async {
                                    Get.back();
                                    final ok = await controller.deleteCoach(coach.coachId);
                                    if (ok) { controller.fetchCoaches(); Get.snackbar('Success', 'Coach deleted'); }
                                    else Get.snackbar('Error', controller.errorMessage.value);
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ));
                          },
                        )
                      : null,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
