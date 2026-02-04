import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/fixture_controller.dart';
import '../../controllers/league_controller.dart';
import '../../controllers/referee_controller.dart';
import '../../controllers/team_controller.dart';
import '../../controllers/venue_controller.dart';
import '../../widgets/app_app_bar.dart';

class FixtureFormScreen extends StatelessWidget {
  final String? fixtureId;

  const FixtureFormScreen({super.key, this.fixtureId});

  @override
  Widget build(BuildContext context) {
    final fc = Get.find<FixtureController>();
    final lc = Get.find<LeagueController>();
    final tc = Get.find<TeamController>();
    final vc = Get.find<VenueController>();
    final rc = Get.find<RefereeController>();

    if (lc.leagues.isEmpty) lc.fetchLeagues();
    if (tc.teams.isEmpty) tc.fetchTeams();
    if (vc.venues.isEmpty) vc.fetchVenues();
    if (rc.referees.isEmpty) rc.fetchReferees();

    final isEdit = fixtureId != null;
    final fixture = isEdit ? fc.fixtures.firstWhereOrNull((f) => f.fixtureId == fixtureId) : null;

    final leagueId = (fixture?.leagueId ?? '').obs;
    final homeTeamId = (fixture?.homeTeamId ?? '').obs;
    final awayTeamId = (fixture?.awayTeamId ?? '').obs;
    final venueId = (fixture?.venueId ?? '').obs;
    final refereeId = (fixture?.refereeId ?? '').obs;
    final matchDate = (fixture?.matchDate ?? DateTime.now()).obs;

    return Scaffold(
      appBar: AppAppBar(title: isEdit ? 'Edit Fixture' : 'New Fixture'),
      body: Obx(() {
        if (lc.leagues.isEmpty || tc.teams.isEmpty || vc.venues.isEmpty || rc.referees.isEmpty) {
          return const Center(child: Text('Add leagues, teams, venues and referees first'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: leagueId.value.isEmpty ? null : leagueId.value,
                decoration: const InputDecoration(labelText: 'League'),
                items: lc.leagues.map((l) => DropdownMenuItem(value: l.leagueId, child: Text(l.name))).toList(),
                onChanged: (v) => leagueId.value = v ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: homeTeamId.value.isEmpty ? null : homeTeamId.value,
                decoration: const InputDecoration(labelText: 'Home Team'),
                items: tc.teams.map((t) => DropdownMenuItem(value: t.teamId, child: Text(t.name))).toList(),
                onChanged: (v) => homeTeamId.value = v ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: awayTeamId.value.isEmpty ? null : awayTeamId.value,
                decoration: const InputDecoration(labelText: 'Away Team'),
                items: tc.teams.map((t) => DropdownMenuItem(value: t.teamId, child: Text(t.name))).toList(),
                onChanged: (v) => awayTeamId.value = v ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: venueId.value.isEmpty ? null : venueId.value,
                decoration: const InputDecoration(labelText: 'Venue'),
                items: vc.venues.map((v) => DropdownMenuItem(value: v.venueId, child: Text(v.name))).toList(),
                onChanged: (v) => venueId.value = v ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: refereeId.value.isEmpty ? null : refereeId.value,
                decoration: const InputDecoration(labelText: 'Referee'),
                items: rc.referees.map((r) => DropdownMenuItem(value: r.refereeId, child: Text(r.fullName ?? 'Unknown'))).toList(),
                onChanged: (v) => refereeId.value = v ?? '',
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Match Date'),
                subtitle: Text('${matchDate.value}'),
                onTap: () async {
                  final date = await showDatePicker(context: context, initialDate: matchDate.value, firstDate: DateTime(2020), lastDate: DateTime(2030));
                  if (date != null) {
                    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(matchDate.value));
                    if (time != null) matchDate.value = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                  }
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (leagueId.value.isEmpty || homeTeamId.value.isEmpty || awayTeamId.value.isEmpty || venueId.value.isEmpty || refereeId.value.isEmpty) {
                    Get.snackbar('Error', 'All fields required');
                    return;
                  }
                  if (homeTeamId.value == awayTeamId.value) {
                    Get.snackbar('Error', 'Home and away must differ');
                    return;
                  }
                  final data = {
                    'leagueId': leagueId.value,
                    'homeTeamId': homeTeamId.value,
                    'awayTeamId': awayTeamId.value,
                    'venueId': venueId.value,
                    'refereeId': refereeId.value,
                    'matchDate': matchDate.value.toIso8601String(),
                  };
                  final ok = isEdit ? await fc.updateFixture(fixtureId!, data) : await fc.createFixture(data);
                  if (ok) { Get.snackbar('Success', 'Fixture saved'); Get.back(); }
                  else Get.snackbar('Error', fc.errorMessage.value);
                },
                child: Text(isEdit ? 'Update' : 'Create'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
