import 'package:dio/dio.dart';

import '../models/fixture_model.dart';
import 'api_client.dart';

class FixtureService {
  final ApiClient _apiClient = ApiClient();

  Future<List<FixtureModel>> getFixtures() async {
    try {
      final response = await _apiClient.dio.get('/fixtures');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => FixtureModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch fixtures');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch fixtures');
    }
  }

  Future<List<FixtureModel>> getFixturesByLeague(String leagueId) async {
    try {
      final response = await _apiClient.dio.get('/leagues/$leagueId/fixtures');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => FixtureModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch fixtures');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch fixtures');
    }
  }

  Future<List<FixtureModel>> getFixturesByTeam(String teamId) async {
    try {
      final response = await _apiClient.dio.get('/teams/$teamId/fixtures');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => FixtureModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch fixtures');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch fixtures');
    }
  }

  Future<List<FixtureModel>> getFixturesByDateRange({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/fixtures/date-range',
        queryParameters: {'startDate': startDate, 'endDate': endDate},
      );
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => FixtureModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch fixtures');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch fixtures');
    }
  }

  Future<FixtureModel> getFixtureById(String id) async {
    try {
      final response = await _apiClient.dio.get('/fixtures/$id');
      if (response.data['success'] == true) {
        return FixtureModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to fetch fixture');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch fixture');
    }
  }

  Future<FixtureModel> createFixture(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/fixtures', data: data);
      if (response.data['success'] == true) {
        return FixtureModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to create fixture');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to create fixture');
    }
  }

  Future<FixtureModel> updateFixture(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/fixtures/$id', data: data);
      if (response.data['success'] == true) {
        return FixtureModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to update fixture');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to update fixture');
    }
  }

  Future<FixtureModel> updateFixtureStatus(String id, String status) async {
    try {
      final response = await _apiClient.dio.patch(
        '/fixtures/$id/status',
        data: {'status': status},
      );
      if (response.data['success'] == true) {
        return FixtureModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to update fixture status');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to update fixture status');
    }
  }

  Future<void> deleteFixture(String id) async {
    try {
      final response = await _apiClient.dio.delete('/fixtures/$id');
      if (response.data['success'] != true) {
        throw Exception('Failed to delete fixture');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to delete fixture');
    }
  }
}
