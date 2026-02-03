import 'package:collection/collection.dart';
import 'package:get/get.dart';

import '../config/app_constants.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/coach_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final CoachService _coachService = CoachService();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final Rx<String?> coachTeamId = Rx<String?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  void _checkAuth() {
    if (_authService.isLoggedIn) {
      currentUser.value = _authService.getCurrentUser();
      _loadCoachTeam();
    } else {
      currentUser.value = null;
      coachTeamId.value = null;
    }
  }

  Future<void> _loadCoachTeam() async {
    try {
      final coaches = await _coachService.getCoaches();
      final email = currentUser.value?.email?.toLowerCase();
      final coach = coaches.where((c) => (c.email ?? '').toLowerCase() == email).firstOrNull;
      coachTeamId.value = coach?.teamId;
    } catch (_) {
      coachTeamId.value = null;
    }
  }

  bool get isLoggedIn => _authService.isLoggedIn;
  bool get isAdmin => currentUser.value?.role == AppConstants.roleAdmin;
  bool get isCoach => coachTeamId.value != null && coachTeamId.value!.isNotEmpty;

  Future<void> login({
    required String email,
    required String password,
    String? role,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _authService.login(
        email: email,
        password: password,
        role: role,
      );
      currentUser.value = result['user'] as UserModel;
      await _loadCoachTeam();
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      errorMessage.value = _userFriendlyError(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _authService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      currentUser.value = result['user'] as UserModel;
      await _loadCoachTeam();
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      errorMessage.value = _userFriendlyError(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  String _userFriendlyError(dynamic e) {
    final msg = e.toString().replaceFirst('Exception: ', '');
    if (msg.contains('timeout') || msg.contains('aborted') || msg.contains('Connection timed out')) {
      return 'Server is waking up. Please wait a moment and try again.';
    }
    if (msg.contains('Connection refused') || msg.contains('Failed host lookup')) {
      return 'No connection. Check your internet.';
    }
    return msg;
  }

  Future<void> updatePassword({required String currentPassword, required String newPassword}) async {
    await _authService.updatePassword(currentPassword: currentPassword, newPassword: newPassword);
  }

  void logout() {
    _authService.logout();
    currentUser.value = null;
    coachTeamId.value = null;
    Get.offAllNamed(AppRoutes.public);
  }
}
