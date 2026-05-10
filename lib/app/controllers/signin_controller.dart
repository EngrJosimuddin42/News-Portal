import 'package:get/get.dart';
import 'package:news_break/app/widgets/app_snackbar.dart';
import '../modules/me/settings/about/legal_view.dart';
import 'auth/auth_controller.dart';
import '../routes/app_pages.dart';

class SignInController extends GetxController {
  final RxBool isExpanded = false.obs;
  var isLoading = false.obs;

  void toggleExpand() => isExpanded.value = true;

  void continueWithFacebook() {
    AppSnackbar.facebook(message: 'Signing in with Facebook...');
    _loginSuccess(name: 'Amalia', email: 'amalia@facebook.com');
  }

  void continueWithGoogle() {
    AppSnackbar.google(message: 'Signing in with Google...');
    _loginSuccess(name: 'Amalia', email: 'amalia@gmail.com');
  }

  void continueWithEmail() {
    AppSnackbar.email(message: 'Signing in with Email...');
    _loginSuccess(name: 'Amalia', email: 'amalia@example.com');
  }

  void _loginSuccess({required String name, required String email}) {
    AuthController.to.loginWithUser(name: name, email: email);
    Get.offAllNamed(Routes.HOME);
  }

  void onSkip() {
    AuthController.to.user.value = null;
    Get.offNamed(Routes.HOME);
  }

  void onTermsTap() => Get.to(() => const LegalView(type: LegalType.terms));
  void onPrivacyTap() => Get.to(() => const LegalView(type: LegalType.privacy));
}