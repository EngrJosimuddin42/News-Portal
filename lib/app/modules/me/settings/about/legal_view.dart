import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/modules/me/settings/about/sub_pages/help_widgets.dart';

import '../../../../controllers/me/settings/about_controller.dart';

enum LegalType { terms, privacy, notice }

class LegalView extends StatelessWidget { final LegalType type;

  const LegalView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AboutController(), tag: type.name);
    controller.fetchLegalData(type.name);

    return Obx(() => SharedView(
      isLoading: controller.isLoading.value,
      title: controller.title.value,
      subtitle: controller.subtitle.value,
      lastUpdated: controller.lastUpdated.value,
      importantNotice: controller.importantNotice.value,
      body: controller.body.value,
    ));
  }
}

// ── SharedView
class SharedView extends StatelessWidget {
  final bool isLoading;
  final String title;
  final String subtitle;
  final String lastUpdated;
  final String importantNotice;
  final String body;

  const SharedView({
    super.key,
    required this.isLoading,
    required this.title,
    required this.subtitle,
    required this.lastUpdated,
    required this.importantNotice,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HelpWidgets.helpAppBar(title,showCloseIcon: false),
      body: Column(
          children: [
          const HelpTabBar(),

      Expanded(
        child: ListView(
          padding: EdgeInsets.all(16.h),
          children: [
            Text(subtitle, style:AppTextStyles.headlineLarge.copyWith(color: Color(0xFF242424),fontWeight: FontWeight.w400)),
             SizedBox(height: 12.h),
            Text(lastUpdated, style:AppTextStyles.caption.copyWith(color: Color(0xFF525C5E))),
             SizedBox(height: 16.h),
            Text(importantNotice, style:AppTextStyles.button.copyWith(color:Colors.black)),
             SizedBox(height: 16.h),
            Text(body, style:AppTextStyles.caption.copyWith(color: Colors.black)),
          ],
        ),
      ),
      ],
    ),
    );
  }
}