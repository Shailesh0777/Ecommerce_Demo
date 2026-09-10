import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  // Dio is injected from outside.
  ApiClient(this.dio);

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return dio.get(
      path,
      queryParameters: queryParameters,
    );
  }
}
  // Add other HTTP methods as needed (put, delete, etc.)
  /* This is our first Dependency Injection example.
ApiClient doesn't create Dio.
Instead:
Dio -> ApiClient */