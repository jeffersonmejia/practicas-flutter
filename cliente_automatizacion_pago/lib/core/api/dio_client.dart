import 'package:dio/dio.dart';

class DioClient {

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.1.1",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<Response> get(String path) async {
    return await dio.get(path);
  }

  Future<Response> post(String path, dynamic data) async {
    return await dio.post(path, data: data);
  }
}
