import 'package:get/get.dart';

import '../models/player_model.dart';
import '../services/player_service.dart';

class PlayerController extends GetxController {
  final PlayerService _playerService = PlayerService();

  final RxList<PlayerModel> players = <PlayerModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchPlayers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      players.value = await _playerService.getPlayers();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      players.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPlayersByTeam(String teamId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      players.value = await _playerService.getPlayersByTeam(teamId);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      players.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<PlayerModel?> getPlayerById(String id) async {
    try {
      return await _playerService.getPlayerById(id);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return null;
    }
  }

  Future<bool> createPlayer(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _playerService.createPlayer(data);
      await fetchPlayers();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updatePlayer(String id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _playerService.updatePlayer(id, data);
      await fetchPlayers();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deletePlayer(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _playerService.deletePlayer(id);
      await fetchPlayers();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
