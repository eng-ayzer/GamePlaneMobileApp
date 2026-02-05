import 'package:dio/dio.dart';

import '../models/result_model.dart';
import 'api_client.dart';

class ResultService {
  final ApiClient _apiClient = ApiClient();

  Future<List<ResultModel>> getResults() async {
    try {
      final response = await _apiClient.dio.get('/results');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => ResultModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch results');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch results');
    }
  }

  Future<List<ResultModel>> getResultsByLeague(String leagueId) async {
    try {
      final response = await _apiClient.dio.get('/leagues/$leagueId/results');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => ResultModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch results');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch results');
    }
  }

  Future<List<ResultModel>> getResultsByTeam(String teamId) async {
    try {
      final response = await _apiClient.dio.get('/teams/$teamId/results');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => ResultModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch results');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch results');
    }
  }

  Future<ResultModel?> getResultByFixture(String fixtureId) async {
    try {
      final response = await _apiClient.dio.get('/fixtures/$fixtureId/result');
      if (response.data['success'] == true && response.data['data'] != null) {
        return ResultModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch result');
    }
  }

  Future<ResultModel> getResultById(String id) async {
    try {
      final response = await _apiClient.dio.get('/results/$id');
      if (response.data['success'] == true) {
        return ResultModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to fetch result');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch result');
    }
  }

  Future<ResultModel> createResult(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/results', data: data);
      if (response.data['success'] == true) {
        return ResultModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to create result');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to create result');
    }
  }

  Future<ResultModel> createFixtureResult(String fixtureId, int homeScore, int awayScore) async {
    try {
      final response = await _apiClient.dio.post(
        '/fixtures/$fixtureId/result',
        data: {'homeScore': homeScore, 'awayScore': awayScore},
      );
      if (response.data['success'] == true && response.data['data'] != null) {
        return ResultModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to create result');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to create result');
    }
  }

  Future<ResultModel> updateResult(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/results/$id', data: data);
      if (response.data['success'] == true) {
        return ResultModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to update result');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to update result');
    }
  }

  Future<ResultModel> updateFixtureResult(String fixtureId, int homeScore, int awayScore) async {
    try {
      final response = await _apiClient.dio.put(
        '/fixtures/$fixtureId/result',
        data: {'homeScore': homeScore, 'awayScore': awayScore},
      );
      if (response.data['success'] == true && response.data['data'] != null) {
        return ResultModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to update result');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to update result');
    }
  }

  Future<void> deleteResult(String id) async {
    try {
      final response = await _apiClient.dio.delete('/results/$id');
      if (response.data['success'] != true) {
        throw Exception('Failed to delete result');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to delete result');
    }
  }

  Future<void> deleteFixtureResult(String fixtureId) async {
    try {
      final response = await _apiClient.dio.delete('/fixtures/$fixtureId/result');
      if (response.data['success'] != true) {
        throw Exception('Failed to delete result');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to delete result');
    }
  }
}
