import 'package:get/get.dart';
import '../controllers/ad_banner_controller.dart';
import '../controllers/auth/auth_controller.dart';
import '../controllers/reels/comment_controller.dart';
import '../controllers/create_post_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/me/me_controller.dart';
import '../controllers/me/settings/settings_controller.dart';
import '../controllers/notification/notification_controller.dart';
import '../controllers/premium_controller.dart';
import '../controllers/reels/reels_controller.dart';
import '../controllers/reels/trends_controller.dart';
import '../controllers/social_interaction_controller.dart';
import '../controllers/social_utility_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<ReelsController>(() => ReelsController(), fenix: true);
    Get.lazyPut<TrendsController>(() => TrendsController(), fenix: true);
    Get.lazyPut<NotificationController>(() => NotificationController(), fenix: true);
    Get.lazyPut<MeController>(() => MeController(), fenix: true);
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
    Get.lazyPut<CommentController>(() => CommentController(), fenix: true);
    Get.lazyPut<AdBannerController>(() => AdBannerController(), fenix: true);
    Get.lazyPut<SocialInteractionController>(() => SocialInteractionController(), fenix: true);
    Get.lazyPut<SocialUtilityController>(() => SocialUtilityController(), fenix: true);
    Get.lazyPut<CreatePostController>(() => CreatePostController(), fenix: true);
    Get.lazyPut<PremiumController>(() => PremiumController(), fenix: true);  }
}