import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';

class PeopleCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isFollowing;
  final VoidCallback onDismiss;
  final VoidCallback onFollow;

  const PeopleCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.isFollowing,
    required this.onDismiss,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    return Container( width: 150.w, height: 175.h,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color:Get.isDarkMode?Color(0xFF0B0B0B):Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Get.isDarkMode?Color(0xFF434447):Color(0xFFEDEDED))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: onDismiss,
                  child: Icon(Icons.close, color:Get.isDarkMode?Color(0xFFE0E1E6):Color(0xFF959595), size: 20.sp)),
            ],
          ),
          CircleAvatar( radius: 22.r,
            backgroundColor:Get.isDarkMode? Color(0xFF7A1CA4):Color(0xFF8920BA),
            child: Text(name[0],
                style:AppTextStyles.tagline.copyWith(color: Colors.white))),
           SizedBox(height: 8.h),
          Text(name, style: AppTextStyles.button.copyWith(color:AppColors.white)),
          Text(subtitle, style:AppTextStyles.overline.copyWith(color:Color(0xFFA8A9AE), fontSize: 11.sp)),
          SizedBox(height: 12.h),
          SizedBox( width: 125.w, height: 33.h,
            child: OutlinedButton(
                onPressed: onFollow,
                style: OutlinedButton.styleFrom(
                  backgroundColor: isFollowing ? AppColors.textOnDark :AppColors.textGreen,
                  side: BorderSide(color: isFollowing ? Colors.white24 : const Color(0xFF3498FA)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                child: Text(isFollowing ? 'Following' : '+ Follow',
                  style: AppTextStyles.buttonOutline.copyWith(color: Get.isDarkMode?Colors.white:Color(0xFFFFDFDF))),
              ),
            ),
            ],
          ),
    );
  }
}





