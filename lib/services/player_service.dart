import 'package:dio/dio.dart';

import '../models/player_model.dart';
import 'api_client.dart';

class PlayerService {
  final ApiClient _apiClient = ApiClient();

  Future<List<PlayerModel>> getPlayers() async {
    try {
      final response = await _apiClient.dio.get('/players');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => PlayerModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch players');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch players');
    }
  }

  Future<List<PlayerModel>> getPlayersByTeam(String teamId) async {
    try {
      final response = await _apiClient.dio.get('/teams/$teamId/players');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => PlayerModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch players');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch players');
    }
  }

  Future<PlayerModel> getPlayerById(String id) async {
    try {
      final response = await _apiClient.dio.get('/players/$id');
      if (response.data['success'] == true) {
        return PlayerModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to fetch player');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch player');
    }
  }

  Future<PlayerModel> createPlayer(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/players', data: data);
      if (response.data['success'] == true) {
        return PlayerModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to create player');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to create player');
    }
  }

  Future<PlayerModel> updatePlayer(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/players/$id', data: data);
      if (response.data['success'] == true) {
        return PlayerModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to update player');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to update player');
    }
  }

  Future<void> deletePlayer(String id) async {
    try {
      final response = await _apiClient.dio.delete('/players/$id');
      if (response.data['success'] != true) {
        throw Exception('Failed to delete player');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to delete player');
    }
  }
}
