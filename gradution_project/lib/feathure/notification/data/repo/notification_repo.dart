import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_endpoint.dart';
import '../model/notification_model.dart';

class NotificationRepo {
  Future<Either<String, List<AppNotification>>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        return Left("يجب تسجيل الدخول أولاً");
      }

      final response = await APIHelper().getData(
        url: EndPoints.getNotifications,
        token: token,
        data: {},
      );

      if (response.statusCode == 200) {
        final dataList = response.data as List;
        List<AppNotification> notifications =
            dataList.map((item) => AppNotification.fromJson(item)).toList();
        return Right(notifications);
      } else {
        return Left("فشل في تحميل الإشعارات: ${response.statusCode}");
      }
    } catch (e) {
      return Left("حدث خطأ: ${e.toString()}");
    }
  }

  Future<Either<String, String>> acceptNotification(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        return Left("يجب تسجيل الدخول أولاً");
      }

      final response = await APIHelper().postData(
        url: EndPoints.postRespons,
        token: token,
        data: {
          "notificationId": id,
          "response": "accepted",
        },
      );

      if (response.statusCode == 200) {
        return Right("تم قبول الإشعار بنجاح");
      } else {
        return Left("فشل في قبول الإشعار: ${response.statusCode}");
      }
    } catch (e) {
      return Left("حدث خطأ: ${e.toString()}");
    }
  }

  Future<Either<String, String>> rejectNotification(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        return Left("يجب تسجيل الدخول أولاً");
      }

      final response = await APIHelper().postData(
        url: EndPoints.postRespons, // ✅ نفس endpoint
        token: token,
        data: {
          "notificationId": id,
          "response": "rejected",
        },
      );

      if (response.statusCode == 200) {
        return Right("تم رفض الإشعار بنجاح");
      } else {
        return Left("فشل في رفض الإشعار: ${response.statusCode}");
      }
    } catch (e) {
      return Left("حدث خطأ: ${e.toString()}");
    }
  }
}
