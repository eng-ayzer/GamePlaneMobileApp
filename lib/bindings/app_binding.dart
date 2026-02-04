import 'package:get/get.dart';

import '../controllers/coach_controller.dart';
import '../controllers/fixture_controller.dart';
import '../controllers/league_controller.dart';
import '../controllers/player_controller.dart';
import '../controllers/referee_controller.dart';
import '../controllers/result_controller.dart';
import '../controllers/team_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/venue_controller.dart';

/// Ensures all data controllers are registered - call before any CRUD screen
/// permanent: true keeps controllers in memory so data is not lost when navigating
void ensureDataControllers() {
  if (!Get.isRegistered<LeagueController>()) Get.put(LeagueController(), permanent: true);
  if (!Get.isRegistered<TeamController>()) Get.put(TeamController(), permanent: true);
  if (!Get.isRegistered<FixtureController>()) Get.put(FixtureController(), permanent: true);
  if (!Get.isRegistered<PlayerController>()) Get.put(PlayerController(), permanent: true);
  if (!Get.isRegistered<CoachController>()) Get.put(CoachController(), permanent: true);
  if (!Get.isRegistered<VenueController>()) Get.put(VenueController(), permanent: true);
  if (!Get.isRegistered<RefereeController>()) Get.put(RefereeController(), permanent: true);
  if (!Get.isRegistered<ResultController>()) Get.put(ResultController(), permanent: true);
  if (!Get.isRegistered<UserController>()) Get.put(UserController(), permanent: true);
}
