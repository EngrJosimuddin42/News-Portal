import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../controllers/me/settings/settings_controller.dart';

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
    return Obx(() {
      final isDark = SettingsController.to.isDarkMode.value;

      return Container(
        width: 150.w,height: 175.h,
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B0B0B) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? const Color(0xFF434447) : const Color(0xFFEDEDED),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onDismiss,
                  child: Icon(
                    Icons.close,
                    color: isDark ? const Color(0xFFE0E1E6) : const Color(0xFF959595),
                    size: 20.sp,
                  ),
                ),
              ],
            ),
            CircleAvatar(
              radius: 22.r,
              backgroundColor: isDark ? const Color(0xFF7A1CA4) : const Color(0xFF8920BA),
              child: Text(name[0], style: AppTextStyles.tagline.copyWith(color: Colors.white))),
            SizedBox(height: 8.h),
            Text(name, style: AppTextStyles.button.copyWith(color: AppColors.white, letterSpacing: 0, height: 1.0)),
            SizedBox(height: 6.h),
            Text(subtitle, style: AppTextStyles.overline.copyWith(color: const Color(0xFFA8A9AE), fontSize: 11.sp, letterSpacing: 0, height: 1.0)),
            SizedBox(height: 12.h),
            SizedBox(
              width: 125.w, height: 33.h,
              child: OutlinedButton(
                onPressed: onFollow,
                style: OutlinedButton.styleFrom(
                  backgroundColor: isFollowing ? AppColors.textOnDark : AppColors.textGreen,
                  side: BorderSide(color: isFollowing ? Colors.white24 : const Color(0xFF3498FA)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                child: Text(
                  isFollowing ? 'following'.tr : '+ ${'follow'.tr}',
                  style: AppTextStyles.buttonOutline.copyWith( letterSpacing: 0, height: 1.0,
                    color: isDark ? Colors.white : const Color(0xFFFFDFDF),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}