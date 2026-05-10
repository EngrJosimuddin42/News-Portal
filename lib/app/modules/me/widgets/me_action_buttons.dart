import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../controllers/me/me_controller.dart';
import '../../../controllers/me/settings/settings_controller.dart';

class MeActionButtons extends GetView<MeController> {
  const MeActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Obx(() {
        final isDark = SettingsController.to.isDarkMode.value;
        final borderColor = isDark ? const Color(0xFF1D1D1D) : const Color(0xFFEDEDED);

        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.isCreator.value
                    ? controller.onCreatorDashboard
                    : controller.onBecomeCreator,
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(160.w, 50.h),
                  backgroundColor: AppColors.button,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  controller.isCreator.value
                      ? 'Creator dashboard'
                      : 'Become a creator',
                  style: AppTextStyles.buttonOutline.copyWith(color: AppColors.white),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  OutlinedButton(
                    onPressed: controller.onCompleteProfile,
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(160.w, 50.h),
                      backgroundColor: AppColors.button,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: borderColor),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      'Complete profile',
                      style: AppTextStyles.buttonOutline.copyWith(color: AppColors.white),
                    ),
                  ),
                  // Red dot
                  if (!controller.isProfileComplete)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        width: 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: AppColors.linkColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}