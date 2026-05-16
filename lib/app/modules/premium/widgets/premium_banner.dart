import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/modules/premium/premium_screen.dart';
import 'package:news_break/app/bindings/premium_binding.dart';
import '../../../controllers/me/settings/settings_controller.dart';
import '../../../controllers/premium_controller.dart';

class PremiumBanner extends StatelessWidget {
  const PremiumBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PremiumController>();

    return Obx(() {
      final isDark = SettingsController.to.isDarkMode.value;

      SettingsController.to.selectedLanguage.value;

      return Container(
        height: 157.h,
        width: 335.w,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? const Color(0xFF282828) : const Color(0xFFEDEDED)),
          borderRadius: BorderRadius.circular(16.r)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.bannerTitle,
                    style: AppTextStyles.buttonOutline.copyWith(color: AppColors.white)),
                  SizedBox(height:12.h),
                  Text(controller.bannerSubtitle,
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.info,letterSpacing: 0,height: 1.5,fontSize: 11)),
                ],
              ),
            ),
            SizedBox(width: 2),
            Container(
              height: 40.h,width: 105.w,
              decoration: BoxDecoration(
                gradient: AppColors.customGradient,
                borderRadius: BorderRadius.circular(8.r)),
              child: ElevatedButton(
                onPressed: () => Get.to(
                      () => const PremiumScreen(),
                  binding: PremiumBinding()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h)),
                child: Text(
                  controller.bannerButtonText,
                  style: AppTextStyles.textSmall.copyWith(
                    color: Colors.white, letterSpacing: 0, height: 1.0,fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}