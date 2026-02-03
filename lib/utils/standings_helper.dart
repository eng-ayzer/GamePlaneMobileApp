import '../models/fixture_model.dart';
import '../models/team_model.dart';
import '../models/team_standing_model.dart';

/// Calculates league standings from fixtures with completed results
class StandingsHelper {
  static List<TeamStandingModel> calculateStandings({
    required List<FixtureModel> fixtures,
    required List<TeamModel> teams,
    required String leagueId,
  }) {
    final teamIds = teams.where((t) => t.leagueId == leagueId).map((t) => t.teamId).toSet();
    final teamMap = {for (var t in teams.where((t) => t.leagueId == leagueId)) t.teamId: t};

    final stats = <String, _TeamStats>{};
    for (final teamId in teamIds) {
      stats[teamId] = _TeamStats(teamId: teamId);
    }

    for (final fixture in fixtures) {
      if (fixture.leagueId != leagueId) continue;
      if (fixture.status != 'Completed' || fixture.result == null) continue;
      if (!teamIds.contains(fixture.homeTeamId) || !teamIds.contains(fixture.awayTeamId)) continue;

      final homeScore = fixture.result!.homeScore ?? 0;
      final awayScore = fixture.result!.awayScore ?? 0;

      stats[fixture.homeTeamId]!.played++;
      stats[fixture.awayTeamId]!.played++;
      stats[fixture.homeTeamId]!.goalsFor += homeScore;
      stats[fixture.homeTeamId]!.goalsAgainst += awayScore;
      stats[fixture.awayTeamId]!.goalsFor += awayScore;
      stats[fixture.awayTeamId]!.goalsAgainst += homeScore;

      if (homeScore > awayScore) {
        stats[fixture.homeTeamId]!.won++;
        stats[fixture.homeTeamId]!.points += 3;
        stats[fixture.awayTeamId]!.lost++;
      } else if (awayScore > homeScore) {
        stats[fixture.awayTeamId]!.won++;
        stats[fixture.awayTeamId]!.points += 3;
        stats[fixture.homeTeamId]!.lost++;
      } else {
        stats[fixture.homeTeamId]!.drawn++;
        stats[fixture.homeTeamId]!.points += 1;
        stats[fixture.awayTeamId]!.drawn++;
        stats[fixture.awayTeamId]!.points += 1;
      }
    }

    final standings = <TeamStandingModel>[];
    var position = 1;
    final sorted = stats.values.toList()
      ..sort((a, b) {
        if (b.points != a.points) return b.points.compareTo(a.points);
        final gdA = a.goalsFor - a.goalsAgainst;
        final gdB = b.goalsFor - b.goalsAgainst;
        if (gdB != gdA) return gdB.compareTo(gdA);
        return b.goalsFor.compareTo(a.goalsFor);
      });

    for (final s in sorted) {
      final team = teamMap[s.teamId];
      if (team != null) {
        standings.add(TeamStandingModel(
          team: team,
          played: s.played,
          won: s.won,
          drawn: s.drawn,
          lost: s.lost,
          goalsFor: s.goalsFor,
          goalsAgainst: s.goalsAgainst,
          goalDifference: s.goalsFor - s.goalsAgainst,
          points: s.points,
          position: position++,
        ));
      }
    }

    return standings;
  }
}

class _TeamStats {
  String teamId;
  int played = 0;
  int won = 0;
  int drawn = 0;
  int lost = 0;
  int goalsFor = 0;
  int goalsAgainst = 0;
  int points = 0;

  _TeamStats({required this.teamId});
}
