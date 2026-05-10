import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../../../controllers/me/settings/what_we_do_controller.dart';
import 'creator_page_view.dart';
import 'help_widgets.dart';

class WhatWeDoView extends StatelessWidget {
   WhatWeDoView({super.key});

  final WhatWeDoController controller = Get.put(WhatWeDoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HelpWidgets.helpAppBar('Help Center'),
      body: Column(
        children: [
          const HelpTabBar(),
          Expanded(
            child:Obx(() {
              if (controller.isLoading.value) {
                return  Center(
                    child: CircularProgressIndicator(color:AppColors.black));
              }

              return ListView(
                children: [
                  // Hero section
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(24.h),
                    child: Column(
                      children: [
                        Text(controller.userStats.value, style: AppTextStyles.caption.copyWith(color: Color(0xFF242424))),
                         SizedBox(height: 8.h),
                        Text(controller.welcomeHeadline.value, textAlign: TextAlign.center,
                            style: AppTextStyles.chart.copyWith( color: Colors.black)),
                         SizedBox(height: 16.h),
                        Image.asset(controller.heroImagePath)
                      ],
                    ),
                  ),

                  // Stay alert section
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(24.h),
                    child: Column(
                      children: [
                        Text(controller.safetyTitle.value, textAlign: TextAlign.center,
                            style: AppTextStyles.headlineLarge.copyWith(color: Color(0xFF242424), fontWeight: FontWeight.w400)),
                         SizedBox(height: 12.h),
                        Text(controller.safetyDesc.value, textAlign: TextAlign.center,
                            style: AppTextStyles.caption.copyWith(color: Color(0xFF525C5E))),
                         SizedBox(height: 16.h),
                        Image.asset(controller.safetyImagePath)])),

                  // CTA Sections (Contributors, Publishers, Advertisers)
                  ...controller.ctaSections.map((section) =>
                      _ctaSection(
                        tag: section.tag,
                        title: section.title,
                        subtitle: section.subtitle,
                        buttonLabel: section.buttonLabel,
                        onTap: () => Get.to(() => CreatorPageView(pageKey: section.pageKey)),
                      )),
                  HelpWidgets.helpFooter(),
                ],
              );
            }
              )
          ),
        ],
      ),
    );
  }


  Widget _ctaSection({
    required String tag,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(tag, style: AppTextStyles.bodyMedium.copyWith(color: Color(0xFF242424))),
           SizedBox(height: 8.h),
          Text(title, style: AppTextStyles.title.copyWith(color: Color(0xFF242424))),
           SizedBox(height: 8.h),
          Text(subtitle, style:AppTextStyles.overline.copyWith(color: Color(0xFF525C5E))),
           SizedBox(height: 24.h),
          SizedBox(width: 190.w, height: 48.h,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor:Color(0xFF7B83EB),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 14.h)),
              child: Text(buttonLabel, style:AppTextStyles.buttonOutline.copyWith(color: Colors.white)))),
        ],
      ),
    );
  }
}
