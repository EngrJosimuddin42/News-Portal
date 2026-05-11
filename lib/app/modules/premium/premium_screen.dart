import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/me/settings/settings_controller.dart';
import '../../controllers/premium_controller.dart';
import 'payment_method_screen.dart';

class PremiumScreen extends GetView<PremiumController> {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = SettingsController.to.isDarkMode.value;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios, color: AppColors.textOnDark, size: 20.sp),
                    ),
                  ],
                ),
              ),

              Text('choose_your_plan'.tr, style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
              SizedBox(height: 12.h),
              Text('become_premium'.tr, style: AppTextStyles.bodyLarge),
              SizedBox(height: 24.h),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Obx(() => Column(
                    children: [
                      _planCard(
                        isDark: isDark,
                        isSelected: controller.isYearly.value,
                        badge: 'best_value'.tr,
                        plan: 'yearly'.tr,
                        price: controller.yearlyPrice.value,
                        period: '/${'year'.tr}',
                        onTap: () => controller.selectPlan(true),
                      ),
                      SizedBox(height: 16.h),
                      _planCard(
                        isDark: isDark,
                        isSelected: !controller.isYearly.value,
                        plan: 'monthly'.tr,
                        price: controller.monthlyPrice.value,
                        period: '/${'month'.tr}',
                        onTap: () => controller.selectPlan(false),
                      ),
                      SizedBox(height: 24.h),

                      SizedBox(
                        width: double.infinity, height: 48.h,
                        child: ElevatedButton(
                          onPressed: () => Get.to(() => const PaymentMethodScreen()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? const Color(0xFF7B83EB) : const Color(0xFF7B82EB),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            elevation: 0,
                          ),
                          child: Text(controller.freeTrialText.value,
                              style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Text(
                        controller.disclaimerText.value,
                        style: AppTextStyles.display.copyWith(
                          color: isDark ? Colors.white : AppColors.textOnDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _planCard({
    required bool isDark,
    required bool isSelected,
    String? badge,
    required String plan,
    required String price,
    required String period,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isDark ? const Color(0xFF535353) : const Color(0xFFEDEDED),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF316FE2) : const Color(0xFF477EE5),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Text(badge, style: AppTextStyles.textSmall.copyWith(color: Colors.white)),
              ),
              SizedBox(height: 12.h),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(plan, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(text: price, style: AppTextStyles.heading.copyWith(color: AppColors.price)),
                    TextSpan(text: period, style: AppTextStyles.small.copyWith(color: AppColors.price)),
                  ]),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ...controller.features.map((f) => _featureRow(f['title']!, f['subtitle']!)),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(AppAssets.premiumIcon, height: 20.h, width: 20.w,
              colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.textSmall.copyWith(color: AppColors.white)),
                SizedBox(height: 8.h),
                Text(subtitle, style: AppTextStyles.display.copyWith(color: const Color(0xFFC4C4C4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}