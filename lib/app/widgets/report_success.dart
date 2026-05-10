import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';

class ReportSuccess extends StatelessWidget {
  final String message;
  final VoidCallback? onDone;

  const ReportSuccess({
    super.key,
    this.message = 'Thanks for reporting this',
    this.onDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:  EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           SizedBox(height: 8.h),
         SvgPicture.asset(AppAssets.checkmarkIcon,height: 32.h,width: 32.w,
           colorFilter:ColorFilter.mode(Get.isDarkMode?Color(0xFF7B83EB):Color(0xFF7B82EB),BlendMode.srcIn) ,),
           SizedBox(height: 16.h),
          Text(message, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
           SizedBox(height: 24.h),
          SizedBox(width: 311.w, height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                if (onDone != null) {
                  onDone!();
                } else {
                  Get.back();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                padding: EdgeInsets.symmetric(vertical: 12.h)),
              child:Text('Done', style: AppTextStyles.bodySmall.copyWith(color: Get.isDarkMode?Color(0xFF242424):Color(0xFFDBDBDB))))),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}