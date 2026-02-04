import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../config/app_constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio _dio;
  final GetStorage _storage = GetStorage();

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _storage.read<String>(AppConstants.tokenKey);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          _storage.remove(AppConstants.tokenKey);
          _storage.remove(AppConstants.userKey);
        }
        return handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;

  void setToken(String token) {
    _storage.write(AppConstants.tokenKey, token);
  }

  void clearToken() {
    _storage.remove(AppConstants.tokenKey);
    _storage.remove(AppConstants.userKey);
  }

  bool get isAuthenticated {
    final token = _storage.read<String>(AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }
}
