import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../model/meeting_model.dart';

class MeetingRepository {
  final Dio _dio;

  MeetingRepository({Dio? dio})
      : _dio = dio ?? Dio()
          ..options = BaseOptions(
            baseUrl: 'https://omar-server-weynakk-234.vercel.app',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          );

  Future<void> sendMeetingToServer(MeetingModel meeting, String token) async {
    try {
      // التحقق من صحة التوكن قبل الإرسال
      if (token.isEmpty) {
        throw Exception('رمز المصادقة غير صالح');
      }

      // إضافة سجل للبيانات المرسلة (لأغراض التطوير فقط)
      debugPrint('Sending meeting data: ${meeting.toJson()}');

      final response = await _dio.post(
        '/meetings',
        data: meeting.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      // معالجة ردود الخادم المختلفة
      switch (response.statusCode) {
        case 200:
          return;
        case 201:
          return;
        case 400:
          throw Exception('بيانات غير صالحة: ${response.data}');
        case 401:
          throw Exception('انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً');
        case 403:
          throw Exception('غير مصرح به: ${response.data}');
        default:
          throw Exception('خطأ غير متوقع: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: ${e.toString()}');
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return 'خطأ في الخادم: ${e.response?.statusCode} - ${e.response?.data}';
    } else {
      return 'خطأ في الاتصال: ${e.message}';
    }
  }
}
