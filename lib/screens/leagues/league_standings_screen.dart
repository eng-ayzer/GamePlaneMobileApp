import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/fixture_controller.dart';
import '../../controllers/team_controller.dart';
import '../../models/league_model.dart';
import '../../widgets/app_app_bar.dart';
import '../../models/team_standing_model.dart';
import '../../utils/standings_helper.dart';

class LeagueStandingsScreen extends StatelessWidget {
  final LeagueModel league;

  const LeagueStandingsScreen({super.key, required this.league});

  @override
  Widget build(BuildContext context) {
    final fixtureCtrl = Get.find<FixtureController>();
    final teamCtrl = Get.find<TeamController>();

    final standings = StandingsHelper.calculateStandings(
      fixtures: fixtureCtrl.fixtures,
      teams: teamCtrl.teams,
      leagueId: league.leagueId,
    );

    var maxPoints = standings.isEmpty ? 1 : standings.map((s) => s.points).fold(0, (a, b) => a > b ? a : b);
    if (maxPoints == 0) maxPoints = 1;

    return Scaffold(
      appBar: AppAppBar(title: '${league.name} - Standings'),
      body: standings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.leaderboard_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('No results yet', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Add match results to see standings',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await fixtureCtrl.fetchFixtures();
                await teamCtrl.fetchTeams();
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildTableHeader(context),
                  const SizedBox(height: 12),
                  ...standings.map((s) => _StandingsRow(
                        standing: s,
                        maxPoints: maxPoints,
                      )),
                ],
              ),
            ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 32, child: Text('#', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
        const SizedBox(width: 8),
        Expanded(child: Text('Team', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
        SizedBox(width: 28, child: Text('P', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
        SizedBox(width: 28, child: Text('W', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
        SizedBox(width: 28, child: Text('D', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
        SizedBox(width: 28, child: Text('L', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
        SizedBox(width: 32, child: Text('GD', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
        SizedBox(width: 36, child: Text('Pts', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
      ],
    );
  }
}

class _StandingsRow extends StatelessWidget {
  final TeamStandingModel standing;
  final int maxPoints;

  const _StandingsRow({required this.standing, required this.maxPoints});

  @override
  Widget build(BuildContext context) {
    final progress = maxPoints > 0 ? standing.points / maxPoints : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(width: 32, child: SelectableText('${standing.position}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: 8),
                Expanded(child: SelectableText(standing.team.name, style: Theme.of(context).textTheme.titleSmall)),
                SizedBox(width: 28, child: SelectableText('${standing.played}', textAlign: TextAlign.center)),
                SizedBox(width: 28, child: SelectableText('${standing.won}', textAlign: TextAlign.center)),
                SizedBox(width: 28, child: SelectableText('${standing.drawn}', textAlign: TextAlign.center)),
                SizedBox(width: 28, child: SelectableText('${standing.lost}', textAlign: TextAlign.center)),
                SizedBox(width: 32, child: SelectableText('${standing.goalDifference >= 0 ? '+' : ''}${standing.goalDifference}', textAlign: TextAlign.center)),
                SizedBox(width: 36, child: SelectableText('${standing.points}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  standing.position == 1 ? Colors.amber : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
