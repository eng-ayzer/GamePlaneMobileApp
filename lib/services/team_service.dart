import 'package:dio/dio.dart';

import '../models/team_model.dart';
import 'api_client.dart';

class TeamService {
  final ApiClient _apiClient = ApiClient();

  Future<List<TeamModel>> getTeams() async {
    try {
      final response = await _apiClient.dio.get('/teams');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => TeamModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch teams');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch teams');
    }
  }

  Future<List<TeamModel>> getTeamsByLeague(String leagueId) async {
    try {
      final response = await _apiClient.dio.get('/leagues/$leagueId/teams');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => TeamModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch teams');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch teams');
    }
  }

  Future<TeamModel> getTeamById(String id) async {
    try {
      final response = await _apiClient.dio.get('/teams/$id');
      if (response.data['success'] == true) {
        return TeamModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to fetch team');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch team');
    }
  }

  Future<TeamModel> createTeam(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/teams', data: data);
      if (response.data['success'] == true) {
        return TeamModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to create team');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to create team');
    }
  }

  Future<TeamModel> updateTeam(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/teams/$id', data: data);
      if (response.data['success'] == true) {
        return TeamModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to update team');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to update team');
    }
  }

  Future<void> deleteTeam(String id) async {
    try {
      final response = await _apiClient.dio.delete('/teams/$id');
      if (response.data['success'] != true) {
        throw Exception('Failed to delete team');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to delete team');
    }
  }
}
