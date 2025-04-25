// import 'package:dio/dio.dart';

// class DioHelper {
//   static late Dio dio;

//   static void init() {
//     dio = Dio(
//       BaseOptions(
//         baseUrl: 'https://omar-server-weynakk-234.vercel.app/',
//         receiveDataWhenStatusError: true,
//         headers: {
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//       ),
//     );
//   }

//   static Future<Response> postData({
//     required String url,
//     required Map<String, dynamic> data,
//   }) async {
//     return await dio.post(url, data: data);
//   }
// }
