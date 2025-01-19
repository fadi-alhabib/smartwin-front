import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://172.20.10.9:8000/api/",
        headers: {"Accept": "application/json"},
      ),
    );
  }

  static Future<Response?> getData(
      {required String path, Map<String, dynamic>? queryParameters}) async {
    return await dio?.get(path,
        queryParameters: queryParameters,
        options: Options(headers: {
          "Authorization":
              "Bearer 3614|LP5LPchGMPj3aHFcAKfQ6Wn7Vosz2zcywsc7VqhU"
        }));
  }

  static Future<Response?> postData(
      {required String path, Map<String, dynamic>? data}) async {
    return await dio?.post(path,
        data: data,
        options: Options(headers: {
          "Authorization":
              "Bearer 3609|HGdFuysgwdGrFlZMvYcqgnGP8rrQXN9ZCAdRuznm"
        }));
  }
}
