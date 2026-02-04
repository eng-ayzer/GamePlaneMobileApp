abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String public = '/public';
  static const String changePassword = '/change-password';
  static const String register = '/register';
  static const String dashboard = '/dashboard';

  // Entities
  static const String users = '/users';
  static const String userDetail = '/users/:id';
  static const String updateUserPassword = '/users/:id/update-password';
  static const String leagues = '/leagues';
  static const String leagueDetail = '/leagues/:id';
  static const String teams = '/teams';
  static const String teamDetail = '/teams/:id';
  static const String players = '/players';
  static const String playerDetail = '/players/:id';
  static const String coaches = '/coaches';
  static const String coachDetail = '/coaches/:id';
  static const String fixtures = '/fixtures';
  static const String fixtureDetail = '/fixtures/:id';
  static const String results = '/results';
  static const String resultDetail = '/results/:id';
  static const String referees = '/referees';
  static const String refereeDetail = '/referees/:id';
  static const String venues = '/venues';
  static const String venueDetail = '/venues/:id';
}
