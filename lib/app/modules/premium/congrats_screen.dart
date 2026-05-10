import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';

class CongratsScreen extends StatelessWidget {
  const CongratsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height:70.h),
              Center(
                child:SvgPicture.asset(Get.isDarkMode?AppAssets.success1Icon:AppAssets.successIcon, width: 200.w, height: 200.h, fit: BoxFit.contain)),

               SizedBox(height: 32.h),
              Text('Congratulations', style: AppTextStyles.success),
               SizedBox(height: 12.h),
              Text('Your payment is successfully done.', style: AppTextStyles.caption.copyWith(color: AppColors.textOnDark), textAlign: TextAlign.center),
              const Spacer(),
              Center(
                child: SizedBox(width: 311.w, height: 48.h,
                  child: ElevatedButton(
                    onPressed: () => Get.until((route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.confirm,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                    child: Text('Back', style: AppTextStyles.bodySmall.copyWith(color: Colors.white))))),
               SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}