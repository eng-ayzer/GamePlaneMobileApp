import 'package:get/get.dart';

import '../models/league_model.dart';
import '../services/league_service.dart';

class LeagueController extends GetxController {
  final LeagueService _leagueService = LeagueService();

  final RxList<LeagueModel> leagues = <LeagueModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchLeagues() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      leagues.value = await _leagueService.getLeagues();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      leagues.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<LeagueModel?> getLeagueById(String id) async {
    try {
      return await _leagueService.getLeagueById(id);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return null;
    }
  }

  Future<bool> createLeague(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _leagueService.createLeague(data);
      await fetchLeagues();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateLeague(String id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _leagueService.updateLeague(id, data);
      await fetchLeagues();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteLeague(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _leagueService.deleteLeague(id);
      await fetchLeagues();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
