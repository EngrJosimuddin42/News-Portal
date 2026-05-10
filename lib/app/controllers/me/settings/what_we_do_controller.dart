import 'package:get/get.dart';
import '../../../models/what_we_do_model.dart';

class WhatWeDoController extends GetxController {

  var isLoading = true.obs;


  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  void loadInitialData() async {
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  final String heroImagePath = 'assets/images/phone_image.png';
  final String safetyImagePath = 'assets/images/phone.png';

  // Hero & Alert Static Data
  final userStats = 'Over 50 Million Users'.obs;
  final welcomeHeadline = "Welcome to the nation's\nleading news app".obs;
  final safetyTitle = 'Stay alert,\nStay safe'.obs;
  final safetyDesc = 'Stay safe and informed with immediate access to local crime and police alerts and incident reports in your neighborhood'.obs;

  // CTA Sections List
  final List<WhatWeDoSection> ctaSections = [
    WhatWeDoSection(
      tag: 'For Contributors',
      title: 'Share Your Stories',
      subtitle: 'Earn recognition and revenue by sharing important stories from your socials',
      buttonLabel: 'Become a contributor',
      pageKey: 'contributor',
    ),
    WhatWeDoSection(
      tag: 'For Publishers',
      title: 'Expand Your Reach',
      subtitle: 'Broaden your audience and increase your visibility and revenue by sharing your content with millions of new readers on the platform',
      buttonLabel: 'Publish on NewsBreak',
      pageKey: 'publish',
    ),
    WhatWeDoSection(
      tag: 'For Advertisers',
      title: 'Connect Effectively',
      subtitle: 'Reach more than 40 million users across the U.S. and engage with your target audience at the right moment.',
      buttonLabel: 'Advertise on NewsBreak',
      pageKey: 'advertise',
    ),
  ];
}