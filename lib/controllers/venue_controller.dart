import 'package:get/get.dart';

import '../models/venue_model.dart';
import '../services/venue_service.dart';

class VenueController extends GetxController {
  final VenueService _venueService = VenueService();

  final RxList<VenueModel> venues = <VenueModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchVenues() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      venues.value = await _venueService.getVenues();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      venues.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<VenueModel?> getVenueById(String id) async {
    try {
      return await _venueService.getVenueById(id);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return null;
    }
  }

  Future<bool> createVenue(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _venueService.createVenue(data);
      await fetchVenues();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateVenue(String id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _venueService.updateVenue(id, data);
      await fetchVenues();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteVenue(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _venueService.deleteVenue(id);
      await fetchVenues();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
