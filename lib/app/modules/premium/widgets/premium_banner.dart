import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/modules/premium/premium_screen.dart';
import 'package:news_break/app/bindings/premium_binding.dart';
import '../../../controllers/premium_controller.dart';

class PremiumBanner extends StatelessWidget {
  const PremiumBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PremiumController>();
    return Container( height: 145.h, width: 335.w,
          padding:  EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border.all(color:Get.isDarkMode? Color(0xFF282828):Color(0xFFEDEDED)),
            borderRadius: BorderRadius.circular(16.r)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.bannerTitle.value, style: AppTextStyles.buttonOutline.copyWith(color: AppColors.white)),
                    SizedBox(height: 4.h),
                    Text(controller.bannerSubtitle.value, style: AppTextStyles.overline.copyWith(color:AppColors.info)),
                  ],
                ),
              ),

              Container(
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
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h)),
                  child: Text(
                    controller.bannerButtonText.value,
                    style: AppTextStyles.textSmall.copyWith(color: Colors.white))))
            ],
          ),
        );
      }
  }