import 'team_model.dart';

class PlayerModel {
  final String playerId;
  final String teamId;
  final String? firstName;
  final String? lastName;
  final String? position;
  final DateTime? dateOfBirth;
  final int? jerseyNumber;
  final TeamModel? team;

  PlayerModel({
    required this.playerId,
    required this.teamId,
    this.firstName,
    this.lastName,
    this.position,
    this.dateOfBirth,
    this.jerseyNumber,
    this.team,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      playerId: json['player_id'] as String? ?? json['id'] as String? ?? '',
      teamId: json['team_id'] as String? ?? '',
      firstName: json['first_name'] as String? ?? json['firstName'] as String?,
      lastName: json['last_name'] as String? ?? json['lastName'] as String?,
      position: json['position'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'] as String)
          : json['dateOfBirth'] != null
              ? DateTime.tryParse(json['dateOfBirth'] as String)
              : null,
      jerseyNumber: json['jersey_number'] as int? ?? json['jerseyNumber'] as int? ?? json['number'] as int?,
      team: json['team'] != null
          ? TeamModel.fromJson(json['team'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName ?? '',
      'lastName': lastName ?? '',
      'teamId': teamId,
      if (position != null) 'position': position,
      if (jerseyNumber != null) 'number': jerseyNumber,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth!.toIso8601String(),
    };
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
