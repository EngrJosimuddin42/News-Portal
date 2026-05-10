import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/ad_banner_model.dart';
import '../widgets/app_snackbar.dart';

class AdBannerController extends GetxController {
  var isBannerVisible = true.obs;

  final adBanner = AdBannerModel(
    id: 1,
    title: 'FoodRadar',
    body: 'Find Free Food Near You Instantly. 100% Free, No Ads.',
    imageUrl: 'assets/images/publisher.png',
    externalLink: 'https://www.google.com/maps/search/food+near+me',
  ).obs;

  void openExternalLink() async {
    final String urlString = adBanner.value.externalLink;
    final Uri url = Uri.parse(urlString);

    try {
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        AppSnackbar.error(message: "Could not launch the link.");
      }
    } catch (e) {
      AppSnackbar.error(message: "Error: $e");
    }
  }
}