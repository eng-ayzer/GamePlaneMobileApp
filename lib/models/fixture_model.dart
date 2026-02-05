import 'league_model.dart';
import 'team_model.dart';
import 'venue_model.dart';
import 'referee_model.dart';
import 'result_model.dart';

class FixtureModel {
  final String fixtureId;
  final String leagueId;
  final String homeTeamId;
  final String awayTeamId;
  final String venueId;
  final String refereeId;
  final DateTime matchDate;
  final String status;
  final LeagueModel? league;
  final TeamModel? homeTeam;
  final TeamModel? awayTeam;
  final VenueModel? venue;
  final RefereeModel? referee;
  final ResultModel? result;

  FixtureModel({
    required this.fixtureId,
    required this.leagueId,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.venueId,
    required this.refereeId,
    required this.matchDate,
    required this.status,
    this.league,
    this.homeTeam,
    this.awayTeam,
    this.venue,
    this.referee,
    this.result,
  });

  factory FixtureModel.fromJson(Map<String, dynamic> json) {
    return FixtureModel(
      fixtureId: json['fixture_id'] as String? ?? json['id'] as String? ?? '',
      leagueId: json['league_id'] as String? ?? '',
      homeTeamId: json['home_team_id'] as String? ?? json['homeTeamId'] as String? ?? '',
      awayTeamId: json['away_team_id'] as String? ?? json['awayTeamId'] as String? ?? '',
      venueId: json['venue_id'] as String? ?? json['venueId'] as String? ?? '',
      refereeId: json['referee_id'] as String? ?? json['refereeId'] as String? ?? '',
      matchDate: DateTime.parse(
        json['match_date'] as String? ?? json['matchDate'] as String? ?? DateTime.now().toIso8601String(),
      ),
      status: json['status'] as String? ?? 'Scheduled',
      league: json['league'] != null
          ? LeagueModel.fromJson(json['league'] as Map<String, dynamic>)
          : null,
      homeTeam: json['homeTeam'] != null
          ? TeamModel.fromJson(json['homeTeam'] as Map<String, dynamic>)
          : json['home_team'] != null
              ? TeamModel.fromJson(json['home_team'] as Map<String, dynamic>)
              : null,
      awayTeam: json['awayTeam'] != null
          ? TeamModel.fromJson(json['awayTeam'] as Map<String, dynamic>)
          : json['away_team'] != null
              ? TeamModel.fromJson(json['away_team'] as Map<String, dynamic>)
              : null,
      venue: json['venue'] != null
          ? VenueModel.fromJson(json['venue'] as Map<String, dynamic>)
          : null,
      referee: json['referee'] != null
          ? RefereeModel.fromJson(json['referee'] as Map<String, dynamic>)
          : null,
      result: json['result'] != null
          ? ResultModel.fromJson(json['result'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leagueId': leagueId,
      'homeTeamId': homeTeamId,
      'awayTeamId': awayTeamId,
      'venueId': venueId,
      'refereeId': refereeId,
      'matchDate': matchDate.toIso8601String(),
      if (status.isNotEmpty) 'status': status,
    };
  }

  String get displayScore {
    if (result != null) {
      return '${result!.homeScore ?? 0} - ${result!.awayScore ?? 0}';
    }
    return 'vs';
  }
}
