class ResultModel {
  final String resultId;
  final String fixtureId;
  final int? homeScore;
  final int? awayScore;
  final String? report;

  ResultModel({
    required this.resultId,
    required this.fixtureId,
    this.homeScore,
    this.awayScore,
    this.report,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      resultId: json['result_id'] as String? ?? json['id'] as String? ?? '',
      fixtureId: json['fixture_id'] as String? ?? json['fixtureId'] as String? ?? '',
      homeScore: json['home_score'] as int? ?? json['homeScore'] as int?,
      awayScore: json['away_score'] as int? ?? json['awayScore'] as int?,
      report: json['report'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (homeScore != null) 'homeScore': homeScore,
      if (awayScore != null) 'awayScore': awayScore,
      if (report != null) 'report': report,
    };
  }
}
