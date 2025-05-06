class GetMeetingResponseModel {
  Location? location;
  String? sId;
  String? meetingname;
  String? date;
  String? time;
  List<String>? phoneNumbers;
  String? createdBy;
  bool? isPublic;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GetMeetingResponseModel(
      {this.location,
      this.sId,
      this.meetingname,
      this.date,
      this.time,
      this.phoneNumbers,
      this.createdBy,
      this.isPublic,
      this.createdAt,
      this.updatedAt,
      this.iV});

  GetMeetingResponseModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    meetingname = json['meetingname'];
    date = json['date'];
    time = json['time'];
    phoneNumbers = json['phoneNumbers'].cast<String>();
    createdBy = json['createdBy'];
    isPublic = json['isPublic'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    data['meetingname'] = this.meetingname;
    data['date'] = this.date;
    data['time'] = this.time;
    data['phoneNumbers'] = this.phoneNumbers;
    data['createdBy'] = this.createdBy;
    data['isPublic'] = this.isPublic;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
