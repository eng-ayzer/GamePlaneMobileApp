import 'package:get/get.dart';

import '../screens/auth/change_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../widgets/main_layout.dart';
import '../screens/coaches/coaches_screen.dart';
import '../screens/coaches/coach_form_screen.dart';
import '../screens/fixtures/fixtures_screen.dart';
import '../screens/results/results_screen.dart';
import '../screens/fixtures/fixture_form_screen.dart';
import '../screens/fixtures/fixture_detail_screen.dart';
import '../screens/leagues/leagues_screen.dart';
import '../screens/leagues/league_form_screen.dart';
import '../screens/players/players_screen.dart';
import '../screens/players/player_form_screen.dart';
import '../screens/referees/referees_screen.dart';
import '../screens/referees/referee_form_screen.dart';
import '../screens/teams/teams_screen.dart';
import '../screens/teams/team_form_screen.dart';
import '../screens/teams/team_detail_screen.dart';
import '../screens/users/users_screen.dart';
import '../screens/users/user_form_screen.dart';
import '../screens/venues/venues_screen.dart';
import '../screens/venues/venue_form_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/public/public_home_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.public, page: () => const PublicHomeScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.dashboard, page: () => MainLayout(child: const DashboardScreen())),
    GetPage(name: AppRoutes.changePassword, page: () => MainLayout(child: const ChangePasswordScreen())),

    // Users
    GetPage(name: AppRoutes.users, page: () => MainLayout(child: const UsersScreen())),
    GetPage(name: '${AppRoutes.users}/:id', page: () => MainLayout(child: UserFormScreen(userId: Get.parameters['id']))),

    // Leagues
    GetPage(name: AppRoutes.leagues, page: () => MainLayout(child: const LeaguesScreen())),
    GetPage(name: '${AppRoutes.leagues}/:id', page: () => MainLayout(child: LeagueFormScreen(leagueId: Get.parameters['id']))),

    // Teams
    GetPage(name: AppRoutes.teams, page: () => MainLayout(child: const TeamsScreen())),
    GetPage(name: '${AppRoutes.teams}/new', page: () => MainLayout(child: const TeamFormScreen())),
    GetPage(name: '${AppRoutes.teams}/:id', page: () => MainLayout(child: TeamFormScreen(teamId: Get.parameters['id']))),
    GetPage(name: '${AppRoutes.teams}/:id/detail', page: () => MainLayout(child: TeamDetailScreen(teamId: Get.parameters['id']))),

    // Players
    GetPage(name: AppRoutes.players, page: () => MainLayout(child: const PlayersScreen())),
    GetPage(name: '${AppRoutes.players}/new', page: () => MainLayout(child: const PlayerFormScreen())),
    GetPage(name: '${AppRoutes.players}/:id', page: () => MainLayout(child: PlayerFormScreen(playerId: Get.parameters['id']))),

    // Coaches
    GetPage(name: AppRoutes.coaches, page: () => MainLayout(child: const CoachesScreen())),
    GetPage(name: '${AppRoutes.coaches}/new', page: () => MainLayout(child: const CoachFormScreen())),
    GetPage(name: '${AppRoutes.coaches}/:id', page: () => MainLayout(child: CoachFormScreen(coachId: Get.parameters['id']))),

    // Fixtures
    GetPage(name: AppRoutes.fixtures, page: () => MainLayout(child: const FixturesScreen())),
    GetPage(name: '${AppRoutes.fixtures}/new', page: () => MainLayout(child: const FixtureFormScreen())),
    GetPage(name: '${AppRoutes.fixtures}/:id', page: () => MainLayout(child: FixtureFormScreen(fixtureId: Get.parameters['id']))),
    GetPage(name: '${AppRoutes.fixtures}/:id/detail', page: () => MainLayout(child: FixtureDetailScreen(fixtureId: Get.parameters['id'] ?? ''))),

    // Results
    GetPage(name: AppRoutes.results, page: () => MainLayout(child: const ResultsScreen())),

    // Referees
    GetPage(name: AppRoutes.referees, page: () => MainLayout(child: const RefereesScreen())),
    GetPage(name: '${AppRoutes.referees}/new', page: () => MainLayout(child: const RefereeFormScreen())),
    GetPage(name: '${AppRoutes.referees}/:id', page: () => MainLayout(child: RefereeFormScreen(refereeId: Get.parameters['id']))),

    // Venues
    GetPage(name: AppRoutes.venues, page: () => MainLayout(child: const VenuesScreen())),
    GetPage(name: '${AppRoutes.venues}/new', page: () => MainLayout(child: const VenueFormScreen())),
    GetPage(name: '${AppRoutes.venues}/:id', page: () => MainLayout(child: VenueFormScreen(venueId: Get.parameters['id']))),
  ];
}
