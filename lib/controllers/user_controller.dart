import 'package:get/get.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      users.value = await _userService.getUsers();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      users.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      return await _userService.getUserById(id);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return null;
    }
  }

  Future<bool> createUser(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _userService.createUser(data);
      await fetchUsers();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateUser(String id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _userService.updateUser(id, data);
      await fetchUsers();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _userService.deleteUser(id);
      await fetchUsers();
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
