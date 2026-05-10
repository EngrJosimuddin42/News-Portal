import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import '../../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
      final bool isDark = Get.isDarkMode;
      final Color iconColor = isDark ? Colors.white : Colors.black;
      controller;
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.logoIcon, width: 80.w, height: 80.h,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
              SizedBox(height: 40.h),
               CircularProgressIndicator(
                  color:AppColors.white, strokeWidth: 2),
            ],
          ),
        ),
      );
  }
}