class respons {
  String? message;
  AppNotification? notification;

  respons({this.message, this.notification});

  respons.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    notification = json['notification'] != null
        ? new AppNotification.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    return data;
  }
}

class AppNotification {
  String? sId;
  String? userId;
  String? title;
  String? message;
  String? meetingId;
  String? type;
  String? status;
  int? iV;

  AppNotification(
      {this.sId,
      this.userId,
      this.title,
      this.message,
      this.meetingId,
      this.type,
      this.status,
      this.iV});

  AppNotification.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    title = json['title'];
    message = json['message'];
    meetingId = json['meetingId'];
    type = json['type'];
    status = json['status'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['meetingId'] = this.meetingId;
    data['type'] = this.type;
    data['status'] = this.status;
    data['__v'] = this.iV;
    return data;
  }
}
