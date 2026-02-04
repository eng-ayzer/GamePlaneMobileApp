import 'package:dio/dio.dart';

import '../models/venue_model.dart';
import 'api_client.dart';

class VenueService {
  final ApiClient _apiClient = ApiClient();

  Future<List<VenueModel>> getVenues() async {
    try {
      final response = await _apiClient.dio.get('/venues');
      if (response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((e) => VenueModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch venues');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch venues');
    }
  }

  Future<VenueModel> getVenueById(String id) async {
    try {
      final response = await _apiClient.dio.get('/venues/$id');
      if (response.data['success'] == true) {
        return VenueModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to fetch venue');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to fetch venue');
    }
  }

  Future<VenueModel> createVenue(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/venues', data: data);
      if (response.data['success'] == true) {
        return VenueModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to create venue');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to create venue');
    }
  }

  Future<VenueModel> updateVenue(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/venues/$id', data: data);
      if (response.data['success'] == true) {
        return VenueModel.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to update venue');
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to update venue');
    }
  }

  Future<void> deleteVenue(String id) async {
    try {
      final response = await _apiClient.dio.delete('/venues/$id');
      if (response.data['success'] != true) {
        throw Exception('Failed to delete venue');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? e.message ?? 'Failed to delete venue');
    }
  }
}
