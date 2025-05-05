class MeetingModel {
  final String locationName;
  final double lat;
  final double lng;
  final DateTime date;
  final List<String> phoneNumbers;

  MeetingModel({
    required this.locationName,
    required this.lat,
    required this.lng,
    required this.date,
    required this.phoneNumbers,
  });

  Map<String, dynamic> toJson() => {
        'location_name': locationName,
        'lat': lat,
        'lng': lng,
        'date': date.toIso8601String(),
        'phones': phoneNumbers,
      };

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      locationName: json['location_name'],
      lat: json['lat'],
      lng: json['lng'],
      date: DateTime.parse(json['date']),
      phoneNumbers: List<String>.from(json['phones'] ?? []),
    );
  }
}
