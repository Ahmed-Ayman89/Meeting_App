class NotificationResponse {
  final String message;
  final int accepted;
  final int rejected;

  NotificationResponse({
    required this.message,
    required this.accepted,
    required this.rejected,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      message: json['message'] ?? 'تمت العملية بنجاح',
      accepted: json['accepted'] ?? 0,
      rejected: json['rejected'] ?? 0,
    );
  }
}

abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure() : super('حدث خطأ في الخادم');
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('حدث خطأ في الاتصال بالشبكة');
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure() : super('يجب تسجيل الدخول أولاً');
}
