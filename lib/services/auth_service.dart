import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../config/app_constants.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final GetStorage _storage = GetStorage();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? role,
  }) async {
    try {
      final rolesToTry = role != null ? [role] : [AppConstants.roleAdmin, AppConstants.roleCoach];
      Exception? lastError;

      for (final r in rolesToTry) {
        final response = await _apiClient.dio.post(
          '/auth/login',
          data: {
            'email': email.trim().toLowerCase(),
            'password': password,
            'role': r,
          },
          options: Options(
            validateStatus: (status) => status != null && status < 500,
          ),
        );

        if (response.statusCode == 200 && response.data['success'] == true) {
          final data = response.data['data'] as Map<String, dynamic>;
          final token = data['token'] as String;
          final userData = data['user'] as Map<String, dynamic>;

          _apiClient.setToken(token);
          _storage.write(AppConstants.userKey, userData);

          return {
            'success': true,
            'user': UserModel.fromJson(userData),
            'token': token,
          };
        }

        lastError = Exception(_extractError(response.data, response.statusCode));
      }

      throw lastError ?? Exception('Login failed');
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(_extractError(e.response!.data, e.response!.statusCode));
      }
      throw Exception(e.message ?? 'Network error. Check your connection.');
    }
  }

  String _extractError(dynamic data, int? statusCode) {
    if (data == null) return 'Login failed';
    if (data is Map) {
      if (data['error'] != null) return data['error'].toString();
      if (data['message'] != null) return data['message'].toString();
      if (data['errors'] != null) {
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) return errors.first.toString();
        if (errors is Map) return errors.values.first.toString();
      }
    }
    if (statusCode == 400) return 'Invalid email or password';
    if (statusCode == 401) return 'Invalid credentials';
    return 'Login failed';
  }

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email.trim().toLowerCase(),
          'password': password,
          'role': AppConstants.roleCoach,
        },
      );

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final token = data['token'] as String;
        final userData = data['user'] as Map<String, dynamic>;

        _apiClient.setToken(token);
        _storage.write(AppConstants.userKey, userData);

        return {
          'success': true,
          'user': UserModel.fromJson(userData),
          'token': token,
        };
      }
      throw Exception(response.data['error'] ?? 'Registration failed');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['error'] ?? e.message ?? 'Registration failed',
      );
    }
  }

  /// Update current user's password (must be logged in)
  Future<void> updatePassword({required String currentPassword, required String newPassword}) async {
    try {
      final response = await _apiClient.dio.put(
        '/auth/me/password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
        options: Options(validateStatus: (s) => s != null && s < 500),
      );
      if (response.statusCode == 200) return;
      throw Exception(response.data['error'] ?? response.data['message'] ?? 'Update failed');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Update failed');
    }
  }

  void logout() {
    _apiClient.clearToken();
  }

  UserModel? getCurrentUser() {
    final userData = _storage.read<Map<String, dynamic>>(AppConstants.userKey);
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  bool get isLoggedIn => _apiClient.isAuthenticated;
}
