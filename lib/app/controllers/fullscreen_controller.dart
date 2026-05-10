import 'package:get/get.dart';
import '../routes/app_pages.dart';

class FullscreenController extends GetxController {
  void onAllow() {
    Get.offNamed(Routes.SIGNIN);
  }

  void onSkip() {
    Get.offNamed(Routes.SIGNIN);
  }
}