import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/fixture_controller.dart';
import '../../controllers/league_controller.dart';
import '../../controllers/player_controller.dart';
import '../../controllers/team_controller.dart';
import '../../widgets/app_app_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final authController = Get.find<AuthController>();
    final fixtureCtrl = Get.put(FixtureController());
    final leagueCtrl = Get.put(LeagueController());
    final teamCtrl = Get.put(TeamController());
    final playerCtrl = Get.put(PlayerController());
    if (authController.isAdmin) {
      await fixtureCtrl.fetchFixtures();
      await leagueCtrl.fetchLeagues();
      await teamCtrl.fetchTeams();
    } else if (authController.isCoach) {
      final teamId = authController.coachTeamId.value;
      if (teamId != null && teamId.isNotEmpty) {
        await fixtureCtrl.fetchFixturesByTeam(teamId);
        final t = await teamCtrl.getTeamById(teamId);
        if (t != null) teamCtrl.teams.value = [t];
        playerCtrl.fetchPlayersByTeam(teamId);
      }
    } else {
      await fixtureCtrl.fetchFixtures();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: const AppAppBar(title: 'GamePlane'),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${authController.currentUser.value?.firstName ?? "User"}!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                  ),
                  const SizedBox(height: 28),
                  Obx(() {
                    final fixtureCtrl = Get.find<FixtureController>();
                    final leagueCtrl = Get.find<LeagueController>();
                    final teamCtrl = Get.find<TeamController>();
                    final playerCtrl = Get.find<PlayerController>();
                    final resultsCount = fixtureCtrl.fixtures.where((f) => f.status == 'Completed' && f.result != null).length;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: authController.isAdmin
                          ? [
                              _FeatureStat(icon: Icons.event, label: 'Fixtures', value: fixtureCtrl.fixtures.length.toString()),
                              _FeatureStat(icon: Icons.emoji_events, label: 'Leagues', value: leagueCtrl.leagues.length.toString()),
                              _FeatureStat(icon: Icons.groups, label: 'Teams', value: teamCtrl.teams.length.toString()),
                            ]
                          : authController.isCoach
                              ? [
                                  _FeatureStat(icon: Icons.event, label: 'Fixtures', value: fixtureCtrl.fixtures.length.toString()),
                                  _FeatureStat(icon: Icons.groups, label: 'My Team', value: teamCtrl.teams.isEmpty ? '0' : '1'),
                                  _FeatureStat(icon: Icons.person, label: 'Players', value: playerCtrl.players.length.toString()),
                                ]
                              : [
                                  _FeatureStat(icon: Icons.event, label: 'Fixtures', value: fixtureCtrl.fixtures.length.toString()),
                                  _FeatureStat(icon: Icons.scoreboard, label: 'Results', value: resultsCount.toString()),
                                ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _FeatureStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 36, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
        ),
      ],
    );
  }
}
