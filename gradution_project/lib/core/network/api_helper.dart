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
      connectTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10)));

  // get request

  Future<Response> getData({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    return await dio.post(url, data: data);
  }

  // post

  Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    return await dio.post(url, data: data);
  }

  Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    return await dio.post(url, data: data);
  }

  Future<Response> deleteData({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    return await dio.post(url, data: data);
  }
}
