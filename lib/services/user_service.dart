import 'package:dio/dio.dart';

import '../models/user_model.dart';
import 'api_client.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _apiClient.dio.get('/users');
      final data = response.data;

      List<dynamic> list = [];
      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic>) {
        if (data['success'] == true) {
          list = data['data'] as List? ?? data['users'] as List? ?? [];
        } else {
          throw Exception(data['error']?.toString() ?? data['message']?.toString() ?? 'Failed to fetch users');
        }
      } else {
        throw Exception('Invalid response format');
      }

      return list.map((e) {
        if (e is Map<String, dynamic>) return UserModel.fromJson(e);
        throw Exception('Invalid user item: $e');
      }).toList();
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['error'] ?? e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception(msg?.toString() ?? 'Failed to fetch users');
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      final response = await _apiClient.dio.get('/users/$id');
      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to fetch user');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch user');
    }
  }

  Future<UserModel> createUser(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/users', data: data);
      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to create user');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to create user');
    }
  }

  Future<UserModel> updateUser(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/users/$id', data: data);
      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to update user');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      final response = await _apiClient.dio.delete('/users/$id');
      if (response.data['success'] != true) {
        throw Exception('Failed to delete user');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to delete user');
    }
  }
}
