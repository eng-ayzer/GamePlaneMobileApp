/// GamePlane App Constants
/// API Base URL - Production backend
class AppConstants {
  AppConstants._();

  static const String apiBaseUrl = 'https://gameplane-backend.onrender.com/api';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // Fixture Status
  static const List<String> fixtureStatuses = [
    'Scheduled',
    'Completed',
    'Postponed',
  ];

  // User Roles (backend: ADMIN, COACH only)
  static const String roleAdmin = 'ADMIN';
  static const String roleCoach = 'COACH';
}
