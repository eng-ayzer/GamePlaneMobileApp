import 'package:get/get.dart';

import '../models/team_model.dart';
import '../services/team_service.dart';

class TeamController extends GetxController {
  final TeamService _teamService = TeamService();

  final RxList<TeamModel> teams = <TeamModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchTeams() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      teams.value = await _teamService.getTeams();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      teams.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<TeamModel>> fetchTeamsByLeague(String leagueId) async {
    try {
      return await _teamService.getTeamsByLeague(leagueId);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return [];
    }
  }

  Future<TeamModel?> getTeamById(String id) async {
    try {
      return await _teamService.getTeamById(id);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return null;
    }
  }

  Future<String?> createTeam(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final team = await _teamService.createTeam(data);
      await fetchTeams();
      return team.teamId;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateTeam(String id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _teamService.updateTeam(id, data);
      await fetchTeams();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteTeam(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _teamService.deleteTeam(id);
      await fetchTeams();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
