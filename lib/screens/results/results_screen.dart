import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/fixture_controller.dart';
import '../../models/fixture_model.dart';
import '../../widgets/app_app_bar.dart';
import '../../widgets/main_layout.dart';
import '../fixtures/fixture_detail_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadResults());
  }

  void _loadResults() {
    final fixtureCtrl = Get.put(FixtureController());
    final authController = Get.find<AuthController>();
    if (authController.isCoach) {
      final teamId = authController.coachTeamId.value;
      if (teamId != null && teamId.isNotEmpty) {
        fixtureCtrl.fetchFixturesByTeam(teamId);
      } else {
        fixtureCtrl.fixtures.clear();
      }
    } else {
      fixtureCtrl.fetchFixtures();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fixtureCtrl = Get.find<FixtureController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: const AppAppBar(title: 'Results'),
      body: Obx(() {
        var completedFixtures = fixtureCtrl.fixtures
            .where((f) => f.status == 'Completed' && f.result != null)
            .toList();
        if (authController.isCoach) {
          final teamId = authController.coachTeamId.value;
          if (teamId != null) {
            completedFixtures = completedFixtures
                .where((f) => f.homeTeamId == teamId || f.awayTeamId == teamId)
                .toList();
          }
        }
        completedFixtures.sort((a, b) => b.matchDate.compareTo(a.matchDate));

        if (fixtureCtrl.isLoading.value && fixtureCtrl.fixtures.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (completedFixtures.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  authController.isCoach ? 'No results for your team' : 'No results yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete fixtures to see results here',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            _loadResults();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: completedFixtures.length,
            itemBuilder: (_, i) {
              final fixture = completedFixtures[i];
              return _ResultCard(
                fixture: fixture,
                onTap: () => Get.to(() => MainLayout(child: FixtureDetailScreen(fixtureId: fixture.fixtureId))),
              );
            },
          ),
        );
      }),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final FixtureModel fixture;
  final VoidCallback? onTap;

  const _ResultCard({required this.fixture, this.onTap});

  @override
  Widget build(BuildContext context) {
    final homeName = fixture.homeTeam?.name ?? 'TBD';
    final awayName = fixture.awayTeam?.name ?? 'TBD';
    final homeScore = fixture.result?.homeScore ?? 0;
    final awayScore = fixture.result?.awayScore ?? 0;
    final dateStr = DateFormat('MMM d, y').format(fixture.matchDate);

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
              Text(dateStr, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(homeName, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$homeScore - $awayScore',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(awayName, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),
              if (fixture.league?.name != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    fixture.league!.name,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
