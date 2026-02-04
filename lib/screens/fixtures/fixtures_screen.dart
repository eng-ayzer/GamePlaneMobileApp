import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/fixture_controller.dart';
import '../../models/fixture_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_app_bar.dart';
import '../../widgets/main_layout.dart';
import 'fixture_form_screen.dart';
import 'fixture_detail_screen.dart';

class FixturesScreen extends StatefulWidget {
  const FixturesScreen({super.key});

  @override
  State<FixturesScreen> createState() => _FixturesScreenState();
}

class _FixturesScreenState extends State<FixturesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFixtures());
  }

  void _loadFixtures() {
    final controller = Get.put(FixtureController());
    final authController = Get.find<AuthController>();
    final teamId = Get.arguments?['teamId'] as String? ?? (authController.isCoach ? authController.coachTeamId.value : null);
    if (teamId != null && teamId.isNotEmpty) {
      controller.fetchFixturesByTeam(teamId);
    } else if (!authController.isCoach) {
      controller.fetchFixtures();
    } else {
      controller.fixtures.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FixtureController>();
    final authController = Get.find<AuthController>();
    final teamId = Get.arguments?['teamId'] as String? ?? (authController.isCoach ? authController.coachTeamId.value : null);

    return Scaffold(
      appBar: const AppAppBar(title: 'Fixtures'),
      floatingActionButton: authController.isAdmin
          ? FloatingActionButton(
              onPressed: () => Get.to(() => MainLayout(child: const FixtureFormScreen()))?.then((_) => controller.fetchFixtures()),
              child: const Icon(Icons.add),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value && controller.fixtures.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.fixtures.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  authController.isCoach ? 'No fixtures for your team' : 'No fixtures yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            _loadFixtures();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.fixtures.length,
            itemBuilder: (_, i) {
              final fixture = controller.fixtures[i];
              return _FixtureCard(
                fixture: fixture,
                onTap: () => Get.to(() => MainLayout(child: FixtureDetailScreen(fixtureId: fixture.fixtureId)))?.then((_) => controller.fetchFixtures()),
                onEdit: authController.isAdmin ? () => Get.to(() => MainLayout(child: FixtureFormScreen(fixtureId: fixture.fixtureId)))?.then((_) => controller.fetchFixtures()) : null,
                onDelete: authController.isAdmin ? () => _showDeleteDialog(context, controller, fixture) : null,
              );
            },
          ),
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, FixtureController controller, FixtureModel fixture) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Fixture'),
        content: Text('Delete this fixture?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              final ok = await controller.deleteFixture(fixture.fixtureId);
              if (ok) { controller.fetchFixtures(); Get.snackbar('Success', 'Fixture deleted'); }
              else Get.snackbar('Error', controller.errorMessage.value);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _FixtureCard extends StatelessWidget {
  final FixtureModel fixture;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _FixtureCard({required this.fixture, this.onTap, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final homeName = fixture.homeTeam?.name ?? 'TBD';
    final awayName = fixture.awayTeam?.name ?? 'TBD';
    final dateStr = DateFormat('MMM d, y • HH:mm').format(fixture.matchDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText(dateStr, style: Theme.of(context).textTheme.bodySmall),
                  Chip(label: Text(fixture.status), padding: EdgeInsets.zero),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: SelectableText(homeName, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SelectableText(fixture.displayScore, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(child: SelectableText(awayName, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium)),
                ],
              ),
              if (fixture.venue?.name != null) SelectableText('at ${fixture.venue!.name}', style: Theme.of(context).textTheme.bodySmall),
              if (onEdit != null || onDelete != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onEdit != null) IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onEdit),
                    if (onDelete != null) IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: onDelete),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
