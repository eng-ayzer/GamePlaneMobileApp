class VenueModel {
  final String venueId;
  final String name;
  final String? location;

  VenueModel({
    required this.venueId,
    required this.name,
    this.location,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      venueId: json['venue_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (location != null) 'location': location,
    };
  }
}
