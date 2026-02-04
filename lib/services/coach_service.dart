import 'package:dio/dio.dart';

import '../models/coach_model.dart';
import 'api_client.dart';

class CoachService {
  final ApiClient _apiClient = ApiClient();

  Future<List<CoachModel>> getCoaches() async {
    try {
      final response = await _apiClient.dio.get('/coaches');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => CoachModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch coaches');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch coaches');
    }
  }

  Future<List<CoachModel>> getCoachesByTeam(String teamId) async {
    try {
      final response = await _apiClient.dio.get('/teams/$teamId/coaches');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => CoachModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch coaches');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch coaches');
    }
  }

  Future<CoachModel> getCoachById(String id) async {
    try {
      final response = await _apiClient.dio.get('/coaches/$id');
      if (response.data['success'] == true) {
        return CoachModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to fetch coach');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch coach');
    }
  }

  Future<CoachModel> createCoach(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/coaches', data: data);
      if (response.data['success'] == true) {
        return CoachModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to create coach');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to create coach');
    }
  }

  Future<CoachModel> updateCoach(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/coaches/$id', data: data);
      if (response.data['success'] == true) {
        return CoachModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to update coach');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to update coach');
    }
  }

  Future<void> deleteCoach(String id) async {
    try {
      final response = await _apiClient.dio.delete('/coaches/$id');
      if (response.data['success'] != true) {
        throw Exception('Failed to delete coach');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to delete coach');
    }
  }
}
