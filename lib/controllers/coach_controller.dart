import 'package:get/get.dart';

import '../models/coach_model.dart';
import '../services/coach_service.dart';

class CoachController extends GetxController {
  final CoachService _coachService = CoachService();

  final RxList<CoachModel> coaches = <CoachModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchCoaches() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      coaches.value = await _coachService.getCoaches();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      coaches.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<CoachModel>> fetchCoachesByTeam(String teamId) async {
    try {
      return await _coachService.getCoachesByTeam(teamId);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return [];
    }
  }

  Future<CoachModel?> getCoachById(String id) async {
    try {
      return await _coachService.getCoachById(id);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return null;
    }
  }

  Future<bool> createCoach(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _coachService.createCoach(data);
      await fetchCoaches();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateCoach(String id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _coachService.updateCoach(id, data);
      await fetchCoaches();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteCoach(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _coachService.deleteCoach(id);
      await fetchCoaches();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
