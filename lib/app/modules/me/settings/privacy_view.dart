import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../controllers/me/settings/settings_controller.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor:AppColors.scaffoldBg,
        elevation: 0,
        centerTitle: true,
        title: Text('Privacy', style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textOnDark, size: 20.sp),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        children: [
          // Location Toggle Section
          Obx(() => Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location', style: AppTextStyles.large.copyWith(color:AppColors.white)),
                       SizedBox(height: 6.h),
                      Text('Allow others to see your general location in comments, profile, and follower list',
                        style: AppTextStyles.overline,
                      ),
                    ],
                  ),
                ),
                 SizedBox(width: 12.w),
                SizedBox( height: 30.h,
                  child: Transform.scale(
                    scale: 0.7,
                    alignment: Alignment.centerRight,
                    child: Switch(
                      value: SettingsController.to.isLocationVisible.value,
                      onChanged: (val) => SettingsController.to.toggleLocationVisible(val),
                      activeThumbColor:AppColors.textGreen,
                      thumbColor: WidgetStatePropertyAll(AppColors.scaffoldBg))))
              ],
            ),
          )),

          // Blocked Users Navigation
          _buildNavigationTile(
            title: 'Blocked',
            onTap: () => Get.to(() => const BlockedView()),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        child: Row(
          children: [
            Text(title, style: AppTextStyles.bodyMedium.copyWith(color:AppColors.white)),
            const Spacer(),
             Icon(Icons.arrow_forward_ios, color:AppColors.white, size: 16.sp),
          ],
        ),
      ),
    );
  }
}


class BlockedView extends StatelessWidget {
  const BlockedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.scaffoldBg,
      appBar: AppBar(
          backgroundColor:AppColors.scaffoldBg,
        elevation: 0,
        centerTitle: true,
        title: Text('Blocked', style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textOnDark, size: 20.sp))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No users are blocked', style: AppTextStyles.overline.copyWith(fontSize: 14.sp)),
          ],
        ),
      ),
    );
  }
}