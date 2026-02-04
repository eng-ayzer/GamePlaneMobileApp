class RefereeModel {
  final String refereeId;
  final String? fullName;
  final String? certificationLevel;

  RefereeModel({
    required this.refereeId,
    this.fullName,
    this.certificationLevel,
  });

  factory RefereeModel.fromJson(Map<String, dynamic> json) {
    return RefereeModel(
      refereeId: json['referee_id'] as String? ?? json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? json['fullName'] as String?,
      certificationLevel: json['certification_level'] as String? ??
          json['certificationLevel'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'full_name': fullName,
      if (certificationLevel != null) 'certification_level': certificationLevel,
    };
  }
}
