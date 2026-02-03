import 'package:dio/dio.dart';

import '../models/referee_model.dart';
import 'api_client.dart';

class RefereeService {
  final ApiClient _apiClient = ApiClient();

  Future<List<RefereeModel>> getReferees() async {
    try {
      final response = await _apiClient.dio.get('/referees');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => RefereeModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch referees');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch referees');
    }
  }

  Future<RefereeModel> getRefereeById(String id) async {
    try {
      final response = await _apiClient.dio.get('/referees/$id');
      if (response.data['success'] == true) {
        return RefereeModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to fetch referee');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch referee');
    }
  }

  Future<RefereeModel> createReferee(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/referees', data: data);
      if (response.data['success'] == true) {
        return RefereeModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to create referee');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to create referee');
    }
  }

  Future<RefereeModel> updateReferee(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/referees/$id', data: data);
      if (response.data['success'] == true) {
        return RefereeModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to update referee');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to update referee');
    }
  }

  Future<void> deleteReferee(String id) async {
    try {
      final response = await _apiClient.dio.delete('/referees/$id');
      if (response.data['success'] != true) {
        throw Exception('Failed to delete referee');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to delete referee');
    }
  }
}
