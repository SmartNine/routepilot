import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../models/route_task.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors for logging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<RouteTask> optimizeRoute(RouteTask task) async {
    try {
      final response = await _dio.post(
        '/routes/optimize',
        data: task.toJson(),
      );

      return RouteTask.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<RouteTask>> getRouteHistory({int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/routes/history',
        queryParameters: {'limit': limit},
      );

      return (response.data as List)
          .map((json) => RouteTask.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return '连接超时，请检查网络';
      case DioExceptionType.badResponse:
        return error.response?.data['message'] ?? '服务器错误';
      case DioExceptionType.cancel:
        return '请求已取消';
      default:
        return '网络错误，请稍后重试';
    }
  }
}
