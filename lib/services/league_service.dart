import 'package:dio/dio.dart';

import '../models/league_model.dart';
import 'api_client.dart';

class LeagueService {
  final ApiClient _apiClient = ApiClient();

  Future<List<LeagueModel>> getLeagues() async {
    try {
      final response = await _apiClient.dio.get('/leagues');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => LeagueModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch leagues');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch leagues');
    }
  }

  Future<LeagueModel> getLeagueById(String id) async {
    try {
      final response = await _apiClient.dio.get('/leagues/$id');
      if (response.data['success'] == true) {
        return LeagueModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to fetch league');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch league');
    }
  }

  Future<LeagueModel> createLeague(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/leagues', data: data);
      if (response.data['success'] == true) {
        return LeagueModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to create league');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to create league');
    }
  }

  Future<LeagueModel> updateLeague(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/leagues/$id', data: data);
      if (response.data['success'] == true) {
        return LeagueModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to update league');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to update league');
    }
  }

  Future<void> deleteLeague(String id) async {
    try {
      final response = await _apiClient.dio.delete('/leagues/$id');
      if (response.data['success'] != true) {
        throw Exception('Failed to delete league');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to delete league');
    }
  }
}
