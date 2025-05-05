class MeetingModel {
  final String locationName;
  final double lat;
  final double lng;
  final DateTime date;
  final String phoneNumber;

  MeetingModel({
    required this.locationName,
    required this.lat,
    required this.lng,
    required this.date,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'location_name': locationName,
        'lat': lat,
        'lng': lng,
        'date': date.toIso8601String(),
        'phone': phoneNumber,
      };
}
