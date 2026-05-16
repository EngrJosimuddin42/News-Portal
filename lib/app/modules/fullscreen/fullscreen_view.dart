import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../theme/app_colors.dart';
import '../../controllers/fullscreen_controller.dart';

class FullscreenView extends GetView<FullscreenController> {
  const FullscreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              // Skip
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.onSkip,
                  child:Text('skip'.tr, style: AppTextStyles.bodyMedium))),
               SizedBox(height: 100.h),
              // Title
              Text('enable_full_screen'.tr, style: AppTextStyles.headlineLarge),
            SizedBox(height: 32.h),
              // Phone mockup
              Expanded(
                child: Center(
                  child: Image.asset('assets/images/phone_mockup.png', height: 320.h,
                    fit: BoxFit.contain))),
              const Spacer(),
              // Allow button
              SizedBox( width: 311.w, height: 48.h,
                child: ElevatedButton(
                  onPressed: controller.onAllow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side:BorderSide(color: Get.isDarkMode?Colors.white:Color(0xFFEDEDED)),
                      borderRadius: BorderRadius.circular(8.r))),
                     child: Text('allow'.tr, style: AppTextStyles.bodySmall.copyWith(color: Color(0xFF242424))))),

             SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}