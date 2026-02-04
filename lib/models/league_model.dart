class LeagueModel {
  final String leagueId;
  final String name;
  final String? season;
  final DateTime? startDate;
  final DateTime? endDate;

  LeagueModel({
    required this.leagueId,
    required this.name,
    this.season,
    this.startDate,
    this.endDate,
  });

  factory LeagueModel.fromJson(Map<String, dynamic> json) {
    return LeagueModel(
      leagueId: json['league_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String,
      season: json['season'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'] as String)
          : json['startDate'] != null
              ? DateTime.tryParse(json['startDate'] as String)
              : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'] as String)
          : json['endDate'] != null
              ? DateTime.tryParse(json['endDate'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (season != null) 'season': season,
      if (startDate != null) 'start_date': startDate!.toIso8601String(),
      if (endDate != null) 'end_date': endDate!.toIso8601String(),
    };
  }
}
