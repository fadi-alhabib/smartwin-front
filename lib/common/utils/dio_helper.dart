import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sw/common/utils/cache_helper.dart';

class DioHelper {
  static Dio? dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://127.0.0.1:8000/api/",
        headers: {"Accept": "application/json"},
      ),
    );
  }

  static Future<Response?> getData(
      {required String path, Map<String, dynamic>? queryParameters}) async {
    return await dio?.get(
      path,
      queryParameters: queryParameters,
    );
  }

  static Future<Response?> getAuthData(
      {required String path, Map<String, dynamic>? queryParameters}) async {
    log(CacheHelper.getCache(key: 'token'));
    return await dio?.get(path,
        queryParameters: queryParameters,
        options: Options(headers: {
          "Authorization": "Bearer ${CacheHelper.getCache(key: 'token')}",
          "Content-Type": "appilcation/json",
          'Accept': 'application/json'
        }));
  }

  static Future<Response?> postData({
    required String path,
    dynamic data,
    Map<String, String>? headers,
  }) async {
    return await dio?.post(path,
        data: data,
        options: Options(headers: {
          "Authorization": 'Bearer ${CacheHelper.getCache(key: 'token')}',
          'Accept': 'application/json',
          ...?headers,
        }));
  }

  static Future<Response?> patchData({
    required String path,
    dynamic data,
    Map<String, String>? headers,
  }) async {
    return await dio?.patch(path,
        data: data,
        options: Options(headers: {
          "Authorization": 'Bearer ${CacheHelper.getCache(key: 'token')}',
          'Accept': 'application/json',
          ...?headers,
        }));
  }
}
