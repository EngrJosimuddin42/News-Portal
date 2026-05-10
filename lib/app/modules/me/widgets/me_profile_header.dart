import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/me/settings/settings_controller.dart';
import '../../../controllers/social_interaction_controller.dart';
import '../../../widgets/about_profile_sheet.dart';

class MeProfileHeader extends StatelessWidget {
  const MeProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      final isDark = SettingsController.to.isDarkMode.value;
      final textColor = isDark ? Color(0xFFC4C4C4) : Color(0xFFC4C4C4);
      final String? profileUrl = AuthController.to.user.value?.profileImageUrl;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(width: 60.w,  height: 60.h,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Get.isDarkMode ? const Color(0xFF8DC0F9) : const Color(0xFF8DBFF9),
                image: (profileUrl != null && profileUrl.isNotEmpty)
                    ? DecorationImage(
                  image: profileUrl.startsWith('http')
                      ? NetworkImage(profileUrl)
                      : FileImage(File(profileUrl)) as ImageProvider,
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              alignment: Alignment.center,
        child: (profileUrl == null || profileUrl.isEmpty)
            ? SvgPicture.asset(
                  AppAssets.personIcon, height: 32.h, width: 32.h,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn))
            : const SizedBox.shrink(),
          ),

          SizedBox(height: 16.h),

          // Name + meta
          GestureDetector(
              onTap: () =>
                  AboutProfileSheet.show(
                      context,
                      publisherName: AuthController.to.user.value?.name ??
                          'User',
                      publisherType: 'User',
                      publisherMeta: AuthController.to.user.value
                          ?.publisherMeta ?? 'Joined recently'),
              child: Text(AuthController.to.user.value?.name ?? 'User',
                  style: AppTextStyles.bodyMedium.copyWith(color:textColor))),

          SizedBox(height: 16.h),

          // Date and Location Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [

              SvgPicture.asset(
                  AppAssets.calenderIcon, height: 14.h, width: 14.w),
              SizedBox(width: 6.w),
              Text(AuthController.to.user.value?.publisherMeta ?? 'New User',
                  style: AppTextStyles.overline.copyWith(
                      color: AppColors.info)),

              SizedBox(width: 18.w),

              SvgPicture.asset(
                  AppAssets.locationIcon, height: 14.h, width: 14.w),
              SizedBox(width: 4.w),
              Flexible(
                child: Obx(() {
                  final hasHomeLoc = Get
                      .find<HomeController>()
                      .selectedLocation
                      .value != null;
                  return Text(
                    hasHomeLoc
                        ? Get
                        .find<HomeController>()
                        .locationTitle
                        : (AuthController.to.user.value?.location ??
                        'Choose Your Location'),
                    style: AppTextStyles.overline,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  );
                }),
              ),
            ],
          ),

          SizedBox(height: 16.h),
          // Stats
          Obx(() {
            final socialCtrl = Get.find<SocialInteractionController>();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('0', 'Subscribed'),
                _buildVerticalDivider(),
                _statItem(
                    socialCtrl.followersCount.value.toString(), 'Followers'),
                _buildVerticalDivider(),
                _statItem(
                    socialCtrl.followingCount.value.toString(), 'Following'),
              ],
            );
          }),
        ],
      ),
    );
  });
  }

  Widget _statItem(String count, String label) {
    return Column(
      children: [
        Text(count, style:AppTextStyles.bodyMedium),
         SizedBox(height: 2.h),
        Text(label, style:AppTextStyles.overline.copyWith(color: Color(0xFFA7A7A7))),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container( height: 30.h,  width: 1.w,  color: Color(0xFF333333));
  }
}