import 'package:get/get.dart';

import '../models/fixture_model.dart';
import '../services/fixture_service.dart';

class FixtureController extends GetxController {
  final FixtureService _fixtureService = FixtureService();

  final RxList<FixtureModel> fixtures = <FixtureModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchFixtures() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      fixtures.value = await _fixtureService.getFixtures();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      fixtures.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFixturesByLeague(String leagueId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      fixtures.value = await _fixtureService.getFixturesByLeague(leagueId);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      fixtures.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFixturesByTeam(String teamId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      fixtures.value = await _fixtureService.getFixturesByTeam(teamId);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      fixtures.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<FixtureModel?> getFixtureById(String id) async {
    try {
      return await _fixtureService.getFixtureById(id);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return null;
    }
  }

  Future<bool> createFixture(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _fixtureService.createFixture(data);
      await fetchFixtures();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateFixture(String id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _fixtureService.updateFixture(id, data);
      await fetchFixtures();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateFixtureStatus(String id, String status) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _fixtureService.updateFixtureStatus(id, status);
      await fetchFixtures();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteFixture(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _fixtureService.deleteFixture(id);
      await fetchFixtures();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
