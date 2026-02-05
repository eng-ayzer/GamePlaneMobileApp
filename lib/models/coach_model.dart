import 'team_model.dart';

class CoachModel {
  final String coachId;
  final String? teamId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? licenseLevel;
  final int? experienceYears;
  final String? nationality;
  final DateTime? dateOfBirth;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final TeamModel? team;

  CoachModel({
    required this.coachId,
    this.teamId,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.licenseLevel,
    this.experienceYears,
    this.nationality,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.team,
  });

  factory CoachModel.fromJson(Map<String, dynamic> json) {
    return CoachModel(
      coachId: json['coach_id'] as String? ?? json['id'] as String? ?? '',
      teamId: json['team_id'] as String? ?? json['teamId'] as String?,
      firstName: json['first_name'] as String? ?? json['firstName'] as String? ?? '',
      lastName: json['last_name'] as String? ?? json['lastName'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      licenseLevel: json['license_level'] as String? ?? json['licenseLevel'] as String?,
      experienceYears: json['experience_years'] as int? ?? json['experienceYears'] as int?,
      nationality: json['nationality'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'] as String)
          : json['dateOfBirth'] != null
              ? DateTime.tryParse(json['dateOfBirth'] as String)
              : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      team: json['team'] != null
          ? TeamModel.fromJson(json['team'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      if (teamId != null) 'team_id': teamId,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (licenseLevel != null) 'license_level': licenseLevel,
      if (experienceYears != null) 'experience_years': experienceYears,
      if (nationality != null) 'nationality': nationality,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth!.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';
}
