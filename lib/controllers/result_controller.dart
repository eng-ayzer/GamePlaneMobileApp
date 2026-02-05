import 'package:get/get.dart';

import '../models/referee_model.dart';
import '../services/referee_service.dart';

class RefereeController extends GetxController {
  final RefereeService _refereeService = RefereeService();

  final RxList<RefereeModel> referees = <RefereeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchReferees() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      referees.value = await _refereeService.getReferees();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      referees.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<RefereeModel?> getRefereeById(String id) async {
    try {
      return await _refereeService.getRefereeById(id);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return null;
    }
  }

  Future<bool> createReferee(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _refereeService.createReferee(data);
      await fetchReferees();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateReferee(String id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _refereeService.updateReferee(id, data);
      await fetchReferees();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteReferee(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _refereeService.deleteReferee(id);
      await fetchReferees();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
