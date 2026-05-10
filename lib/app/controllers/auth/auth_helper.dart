import 'package:get/get.dart';
import 'package:news_break/app/widgets/app_snackbar.dart';
import 'auth_controller.dart';

class AuthHelper {
  static bool checkLogin() {
    final authController = Get.find<AuthController>();

    if (authController.user.value == null) {
      AppSnackbar.error(message: "Please login to use this feature");
      return false;
    }
    return true;
  }
}