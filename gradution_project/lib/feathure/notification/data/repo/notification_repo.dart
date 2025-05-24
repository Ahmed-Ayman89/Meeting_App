import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_endpoint.dart';
import '../model/notification_model.dart';
import 'response.dart';

class NotificationRepo {
  Future<Either<String, List<AppNotification>>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final refreshToken = prefs.getString('refresh_token');

      if (token == null ||
          token.isEmpty ||
          refreshToken == null ||
          refreshToken.isEmpty) {
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

  Future<Either<String, NotificationResponse>> acceptNotification(
      String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

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
        final data = response.data;
        return Right(NotificationResponse.fromJson(data));
      } else {
        return Left("فشل في قبول الإشعار: ${response.statusCode}");
      }
    } catch (e) {
      return Left("حدث خطأ: ${e.toString()}");
    }
  }

  Future<Either<String, NotificationResponse>> rejectNotification(
      String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final refreshToken = prefs.getString('refresh_token');

      if (token == null ||
          token.isEmpty ||
          refreshToken == null ||
          refreshToken.isEmpty) {
        return Left("يجب تسجيل الدخول أولاً");
      }

      final response = await APIHelper().postData(
        url: EndPoints.postRespons,
        token: token,
        data: {
          "notificationId": id,
          "response": "rejected",
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Right(NotificationResponse.fromJson(data));
      } else {
        return Left("فشل في رفض الإشعار: ${response.statusCode}");
      }
    } catch (e) {
      return Left("حدث خطأ: ${e.toString()}");
    }
  }

  Future<Either<String, bool>> deleteNotification(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) return Left("Authentication required");

      final dio = Dio();
      final response = await dio.post(
        'https://omar-server-weynakk-234.vercel.app/notifications/delete',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {'id': id},
      );

      if (response.statusCode == 200) {
        return Right(true);
      } else {
        return Left("Delete failed: ${response.statusCode}");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        return Left("Invalid endpoint. Contact support");
      }
      return Left("Network error: ${e.message}");
    } catch (e) {
      return Left("System error: $e");
    }
  }
}
