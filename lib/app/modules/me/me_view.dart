import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/modules/me/widgets/me_action_buttons.dart';
import 'package:news_break/app/modules/me/widgets/me_profile_header.dart';
import 'package:news_break/app/modules/me/widgets/me_tabs_view.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/me/settings/settings_controller.dart';
import '../premium/widgets/premium_banner.dart';
import '../../controllers/me/me_controller.dart';

class MeBody extends GetView<MeController> {
  const MeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loggedIn = AuthController.to.user.value != null;
      SettingsController.to.isDarkMode.value;
      return loggedIn
          ? _buildLoggedIn(context)
          : _buildLoggedOut(context);
    });
  }

  // Logged Out
  Widget _buildLoggedOut(BuildContext context) {
    return Obx(() {
      final isDark = SettingsController.to.isDarkMode.value;
      final dividerColor = isDark ? Color(0xFF262530) : Color(0xFFD0CFDA);

      return Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                    child: ElevatedButton(
                        onPressed: controller.onLogin,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            minimumSize: Size(335.w, 40.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                            padding: EdgeInsets.symmetric(vertical: 14.h)),
                        child: Text('Log in or sign up',
                            style: AppTextStyles.bodySmall))),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Text(
                        'Keep your preferences, articles, and topics saved in your NewsBreak account.',
                        style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.info))),

                SizedBox(height: 20.h),

                // Premium banner
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 8.h),
                    child: PremiumBanner()),

                SizedBox(height: 16.h),
                Divider(color: dividerColor, height: 1),
                SizedBox(height: 16.h),

                // Tabs
                const MeTabsView(isLoggedIn: false),
              ],
            ),
          ),
        ],
      );
    });
  }

  //  Logged In
  Widget _buildLoggedIn(BuildContext context) {
    return Obx(() {
      final isDark = SettingsController.to.isDarkMode.value;
      final dividerColor = isDark ? Color(0xFF262530) : Color(0xFFD0CFDA);

      return ListView(
        children: [
          // Profile header
          const MeProfileHeader(),

          SizedBox(height: 16.h),

          // Action buttons
          const MeActionButtons(),

          SizedBox(height: 16.h),

          // Premium banner
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: PremiumBanner()),


          SizedBox(height: 16.h),
          Divider(color: dividerColor, height: 1),
          SizedBox(height: 16.h),

          // Tabs
          const MeTabsView(isLoggedIn: true),

        ],
      );
    });
  }
}
