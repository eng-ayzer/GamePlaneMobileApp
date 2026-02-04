import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../bindings/app_binding.dart';
import '../../controllers/fixture_controller.dart';
import '../../models/fixture_model.dart';
import '../../routes/app_routes.dart';
import '../fixtures/fixture_detail_screen.dart';

/// Public home - Results & Fixtures without login. Admin/Coach login only.
class PublicHomeScreen extends StatefulWidget {
  const PublicHomeScreen({super.key});

  @override
  State<PublicHomeScreen> createState() => _PublicHomeScreenState();
}

class _PublicHomeScreenState extends State<PublicHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ensureDataControllers();
    final fixtureCtrl = Get.put(FixtureController());
    fixtureCtrl.fetchFixtures();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GamePlane'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Fixtures', icon: Icon(Icons.sports_soccer, size: 20)),
            Tab(text: 'Results', icon: Icon(Icons.emoji_events, size: 20)),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Get.offAllNamed(AppRoutes.login),
            icon: const Icon(Icons.login, size: 20),
            label: const Text('Login'),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PublicFixturesTab(onRefresh: _loadData),
          _PublicResultsTab(onRefresh: _loadData),
        ],
      ),
    );
  }
}

class _PublicFixturesTab extends StatelessWidget {
  final VoidCallback onRefresh;

  const _PublicFixturesTab({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FixtureController>();

    return Obx(() {
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
                'No fixtures yet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: () async {
          controller.fetchFixtures();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.fixtures.length,
          itemBuilder: (_, i) {
            final fixture = controller.fixtures[i];
            return _FixtureCard(
              fixture: fixture,
              onTap: () => Get.to(() => FixtureDetailScreen(fixtureId: fixture.fixtureId)),
            );
          },
        ),
      );
    });
  }
}

class _PublicResultsTab extends StatelessWidget {
  final VoidCallback onRefresh;

  const _PublicResultsTab({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FixtureController>();

    return Obx(() {
      final completedFixtures = controller.fixtures
          .where((f) => f.status == 'Completed' && f.result != null)
          .toList();
      completedFixtures.sort((a, b) => b.matchDate.compareTo(a.matchDate));

      if (controller.isLoading.value && controller.fixtures.isEmpty) {
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
                'No results yet',
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
          controller.fetchFixtures();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: completedFixtures.length,
          itemBuilder: (_, i) {
            final fixture = completedFixtures[i];
            return _ResultCard(
              fixture: fixture,
              onTap: () => Get.to(() => FixtureDetailScreen(fixtureId: fixture.fixtureId)),
            );
          },
        ),
      );
    });
  }
}

class _FixtureCard extends StatelessWidget {
  final FixtureModel fixture;
  final VoidCallback? onTap;

  const _FixtureCard({required this.fixture, this.onTap});

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
            ],
          ),
        ),
      ),
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
                  Expanded(child: Text(homeName, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium)),
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
                  Expanded(child: Text(awayName, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium)),
                ],
              ),
              if (fixture.league?.name != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(fixture.league!.name, style: Theme.of(context).textTheme.bodySmall),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
