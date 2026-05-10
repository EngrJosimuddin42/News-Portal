import 'package:get/get.dart';
import 'package:news_break/app/controllers/auth/auth_controller.dart';

import '../modules/premium/congrats_screen.dart';

class PremiumController extends GetxController {
  final isYearly = true.obs;
  final selectedMethod = RxnString();
  final isLoading = false.obs;

  var yearlyPrice = "\$59.99".obs;
  var monthlyPrice = "\$19.99".obs;
  var freeTrialText = "Start 7day Free Trial".obs;
  var disclaimerText = "Lorem ipsum dolor sit amet consectetur. Sapien netus sed turpis euismod tortor. Consequat arcu commodo non habitant sit cras aliquam elementum commodo. Proin viverra pharetra etiam nibh nunc.".obs;
  final List<String> paymentMethods = ['Bkash', 'Nagad', 'Rocket'].obs;

  var bannerTitle = "Try Premium for FREE".obs;
  var bannerSubtitle = "Ad-free reading, boosted \ncomments,smarter \nrecommendations and more.".obs;
  var bannerButtonText = "Upgrade".obs;

  String get userInitial => Get.find<AuthController>().userInitial;

  void selectPlan(bool yearly) => isYearly.value = yearly;

  void selectPaymentMethod(String method) => selectedMethod.value = method;

  Future<void> processPayment() async {
    if (selectedMethod.value == null) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));

      isLoading.value = false;
      Get.to(() => const CongratsScreen());
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Payment failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  final List<Map<String, String>> features = [
    { 'title': 'Ad-free in App',                 'subtitle': 'Millions of articles, videos, local Tvs, etc'},
    { 'title': 'Personalized recommendations',   'subtitle': 'See more stories that match your interest'},
    { 'title': 'Comment Boost',                  'subtitle': 'Receive enhances visibility for your comments'},
    { 'title': 'Avatar ring',                    'subtitle': 'Make your premium membership shine'},
    { 'title': 'Priority support',               'subtitle': 'Email: premium-support@news.com'},
  ].obs;
}