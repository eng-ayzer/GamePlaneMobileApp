import 'league_model.dart';

class TeamModel {
  final String teamId;
  final String leagueId;
  final String name;
  final String? homeGround;
  final DateTime? createdAt;
  final LeagueModel? league;

  TeamModel({
    required this.teamId,
    required this.leagueId,
    required this.name,
    this.homeGround,
    this.createdAt,
    this.league,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      teamId: json['team_id'] as String? ?? json['id'] as String? ?? '',
      leagueId: json['league_id'] as String? ?? '',
      name: json['name'] as String,
      homeGround: json['home_ground'] as String? ?? json['homeGround'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'] as String)
              : null,
      league: json['league'] != null
          ? LeagueModel.fromJson(json['league'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'leagueId': leagueId,
      if (homeGround != null) 'homeGround': homeGround,
    };
  }
}
