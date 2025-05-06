import 'package:intl/intl.dart';

class MeetingModel {
  final String meetingname;
  final String time;
  final double lat;
  final double lng;
  final DateTime date;
  final List<String> phoneNumbers;

  MeetingModel({
    required this.meetingname,
    required this.time,
    required this.lat,
    required this.lng,
    required this.date,
    required this.phoneNumbers,
  });

  Map<String, dynamic> toJson() => {
        'meetingname': meetingname,
        'lat': lat.toString(),
        'lng': lng.toString(),
        'date': DateFormat('yyyy-MM-dd').format(date),
        'time': time, // تنسيق "HH:mm"
        'phoneNumbers': phoneNumbers.join(','),
      };

  // إضافة fromJson لمعالجة الاستجابات
  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      meetingname: json['meetingname'] ?? '',
      time: json['time'] ?? '00:00',
      lat: double.tryParse(json['lat']?.toString() ?? '0') ?? 0.0,
      lng: double.tryParse(json['lng']?.toString() ?? '0') ?? 0.0,
      date: DateTime.parse(json['date']),
      phoneNumbers: (json['phoneNumbers']?.toString().split(',') ?? []),
    );
  }
}
