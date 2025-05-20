import 'package:dio/dio.dart';

import 'api_endpoint.dart';

class APIHelper {
  // singleton
  static final APIHelper _apiHelper = APIHelper._internal();

  factory APIHelper() {
    return _apiHelper;
  }

  APIHelper._internal();

  // declaring dio
  Dio dio = Dio(BaseOptions(
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      receiveDataWhenStatusError: true,
      baseUrl: EndPoints.baseUrl,
      connectTimeout: Duration(seconds: 20),
      sendTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20)));

  // get request

  // post

  Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    required String token,
  }) async {
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    return await dio.post(
      url,
      data: data,
    );
  }

  Future<Response> getData({
    required String url,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    return await dio.get(url, queryParameters: data);
  }

  Future<Response> putData({
    required String token,
    required String url,
    required Map<String, dynamic> data,
  }) async {
    return await dio.put(url, data: data);
  }

  Future<Response> deleteData({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    return await dio.delete(url, data: data);
  }
}
