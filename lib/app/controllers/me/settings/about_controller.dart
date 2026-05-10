import 'package:get/get.dart';

class AboutController extends GetxController {
  var isLoading = true.obs;

  var title = "".obs;
  var subtitle = "".obs;
  var lastUpdated = "".obs;
  var importantNotice = "".obs;
  var body = "".obs;

  void fetchLegalData(String type) async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 500));

      if (type == 'terms') {
        title.value = 'Terms of Use';
        subtitle.value = 'NewsBreak\nTerms of Use';
      } else if (type == 'privacy') {
        title.value = 'Privacy Policy';
        subtitle.value = 'Privacy Policy';
      } else if (type == 'notice') {
        title.value = 'Legal Notice';
        subtitle.value = 'Legal Notice';
      }

      lastUpdated.value = 'Last Updated: October 13, 2025';
      importantNotice.value = 'IMPORTANT NOTICE: DISPUTES ABOUT THESE TERMS ARE SUBJECT TO BINDING ARBITRATION AND A WAIVER OF CLASS ACTION RIGHTS AS DETAILED IN THE "MANDATORY ARBITRATION AND CLASS ACTION WAIVER" PROVISIONS BELOW IN SECTION 14.';
      body.value = 'Lorem ipsum dolor sit amet consectetur. Quis vel scelerisque dignissim nulla urna tellus. Et molestie fusce purus amet in dignissim. Pharetra donec habitasse lectus ultrices lobortis egestas donec non varius. Nisl ornare tellus risus varius arcu. Purus aliquam scelerisque ut quis.';

    } finally {
      isLoading.value = false;
    }
  }
}